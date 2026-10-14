-- AC8StableCamera: removes the roll-driven shift, tilt and pendulum swing from AC8's
-- third-person chase camera (ULiveThirdPersonCameraComponent).
-- Ctrl+F5 toggles the fix on/off in flight to compare with the stock camera.
-- Original values are logged to ue4ss/UE4SS.log as [AC8Cam] lines.
local Config = {
    ZeroRollOffsets = true, -- CorrectRollLeft/RightOffset: sideways camera shift while rolling
    ZeroRollAngles  = true, -- CorrectRollLeft/RightAngle: extra camera rotation while rolling
    DisablePendulum = true, -- Lower/UpperPendularAdditiveBlend: pendulum swing
    RollDelay       = nil,  -- seconds before the camera follows a roll; nil = game default
}

local CLASS = "LiveThirdPersonCameraComponent"
local OFFSETS = { "CameraOffsetNovice", "CameraOffsetExpert" }
local SIDES = { "Left", "Right" }
local ZERO_VEC = { X = 0, Y = 0, Z = 0 }
local ZERO_ROT = { Pitch = 0, Yaw = 0, Roll = 0 }
local enabled = true
local saved = {} -- stock values per component full name

local function log(fmt, ...) print(string.format("[AC8Cam] " .. fmt .. "\n", ...)) end
local function vec(v) return string.format("(%.1f, %.1f, %.1f)", v.X, v.Y, v.Z) end
local function rot(r) return string.format("(P %.1f, Y %.1f, R %.1f)", r.Pitch, r.Yaw, r.Roll) end
local function objName(o) return (o and o:IsValid()) and o:GetFName():ToString() or "none" end
local function readVec(v) return { X = v.X, Y = v.Y, Z = v.Z } end
local function readRot(r) return { Pitch = r.Pitch, Yaw = r.Yaw, Roll = r.Roll } end
local function writeFields(dst, src) for k, v in pairs(src) do dst[k] = v end end

local function snapshot(c)
    local s = {
        RollDelay = c.RollDelay,
        PendLower = c.bEnableLowerPendularAdditiveBlend,
        PendUpper = c.bEnableUpperPendularAdditiveBlend,
    }
    for _, o in ipairs(OFFSETS) do
        for _, side in ipairs(SIDES) do
            s[o .. side .. "Offset"] = readVec(c[o]["CorrectRoll" .. side .. "Offset"])
            s[o .. side .. "Angle"] = readRot(c[o]["CorrectRoll" .. side .. "Angle"])
        end
    end
    return s
end

local function apply(c, s, fix)
    for _, o in ipairs(OFFSETS) do
        for _, side in ipairs(SIDES) do
            writeFields(c[o]["CorrectRoll" .. side .. "Offset"],
                (fix and Config.ZeroRollOffsets) and ZERO_VEC or s[o .. side .. "Offset"])
            writeFields(c[o]["CorrectRoll" .. side .. "Angle"],
                (fix and Config.ZeroRollAngles) and ZERO_ROT or s[o .. side .. "Angle"])
        end
    end
    local calm = fix and Config.DisablePendulum
    c.bEnableLowerPendularAdditiveBlend = (not calm) and s.PendLower
    c.bEnableUpperPendularAdditiveBlend = (not calm) and s.PendUpper
    c.RollDelay = (fix and Config.RollDelay) or s.RollDelay
end

local function describe(c, s)
    log("%s [%s] expert=%s animN=%s animE=%s animN_Nimbus=%s animE_Nimbus=%s",
        c:GetFullName(), c:GetClass():GetFName():ToString(), tostring(c.bIsExpertMode),
        objName(c.AnimDataNovice), objName(c.AnimDataExpert), objName(c.AnimDataNovice_Nimbus), objName(c.AnimDataExpert_Nimbus))
    log("  RollDelay=%.3f PitchDelay=%.3f PitchMag=%.3f PitchReturn=%.3f RollEase=%.3f RollEaseExpert=%.3f (x%.3f) AccelEase=%.3f YawEase=%.3f",
        s.RollDelay, c.PitchDelay, c.PitchMagnitude, c.PitchReturnRatio, c.RollEaseDuration,
        c.RollEaseDurationExpert, c.RollEaseDurationRatioExpert, c.AccelerationEaseDuration, c.YawEaseDuration)
    log("  pendular L/U=%s/%s accelBlend=%s yawAnimBlend=%s AB swing=%.1f addMeter=%.1f addFOV=%.1f",
        tostring(s.PendLower), tostring(s.PendUpper), tostring(c.bEnableAccelerationAdditiveBlend),
        tostring(c.bEnableYawAnimationBlend), c.ABMaxSwingMeter, c.ABMaxAdditionMeter, c.ABMaxAdditionFOV)
    for _, o in ipairs(OFFSETS) do
        local t = c[o]
        log("  %s: rollL %s %s | rollR %s %s | pitchU %s D %s | yawL %s R %s | speedU %s D %s", o,
            vec(s[o .. "LeftOffset"]), rot(s[o .. "LeftAngle"]), vec(s[o .. "RightOffset"]), rot(s[o .. "RightAngle"]),
            vec(t.CorrectPitchUpOffset), vec(t.CorrectPitchDownOffset), vec(t.CorrectYawLeftOffset),
            vec(t.CorrectYawRightOffset), vec(t.CorrectSpeedUpOffset), vec(t.CorrectSpeedDownOffset))
    end
    local m = FindFirstOf("LiveLocalUserSettingsManager")
    if m and m:IsValid() then log("  bUseNimbusCamera=%s", tostring(m.KeyConfigData.bUseNimbusCamera)) end
end

local function update()
    for _, c in ipairs(FindAllOf(CLASS) or {}) do
        if c:IsValid() then
            local key = c:GetFullName()
            local s = saved[key]
            if not s then
                s = snapshot(c)
                saved[key] = s
                local ok, err = pcall(describe, c, s)
                if not ok then log("describe failed: %s", tostring(err)) end
            end
            local ok, err = pcall(apply, c, s, enabled)
            if not ok then log("apply failed on %s: %s", key, tostring(err)) end
        end
    end
end

-- The game can re-create or reset the camera (new mission, camera change), so keep re-applying.
LoopAsync(1000, function()
    ExecuteInGameThread(update)
    return false
end)

RegisterKeyBind(Key.F5, { ModifierKey.CONTROL }, function()
    enabled = not enabled
    log("fix %s", enabled and "ON" or "OFF")
    ExecuteInGameThread(update)
end)

log("loaded (Ctrl+F5 toggles)")
