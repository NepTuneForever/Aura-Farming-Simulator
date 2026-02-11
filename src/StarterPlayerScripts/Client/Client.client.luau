local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SprintController = require(ReplicatedStorage:WaitForChild("ClientSource").SprintingController)

SprintController.Start({
	WalkSpeed = 18,
	SprintSpeed = 26,
	RunAnimation = script:WaitForChild("Running"),
})
