local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local function isMobileDevice()
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		return true
	end
	return false
end

local player = Players.LocalPlayer

if isMobileDevice() then
	local mobileUI = player.PlayerGui:WaitForChild("MobileUI")
	print(mobileUI and true or false)

	for _, gui in pairs(mobileUI:GetChildren()) do
		if gui:IsA("ScreenGui") then
			gui.Enabled = true
		end
	end

	print("UI Mobile ativada")
else
	print("O jogador não está usando um dispositivo móvel.")
end
