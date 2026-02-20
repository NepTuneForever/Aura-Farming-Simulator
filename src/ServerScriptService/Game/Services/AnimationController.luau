local AnimationController = {}
local ActiveTracks = {}

function AnimationController.LoadAnimation(Character, AnimationId)
	local temp = Instance.new("Animation")
	temp.AnimationId = "rbxassetid://" .. AnimationId
	local anim = Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(temp)
	anim:Play()
end

function AnimationController.Toggle(Character, AnimationId, Mode: boolean)
	if not Character then
		return
	end

	local humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	if ActiveTracks[Character] then
		pcall(function()
			ActiveTracks[Character]:Stop()
			ActiveTracks[Character]:Destroy()
		end)
		ActiveTracks[Character] = nil
	end

	if Mode then
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://" .. tostring(AnimationId)

		local track = animator:LoadAnimation(anim)
		track.Looped = true
		track.Priority = Enum.AnimationPriority.Action

		ActiveTracks[Character] = track
		track:Play()

		humanoid.Died:Once(function()
			if ActiveTracks[Character] then
				ActiveTracks[Character]:Stop()
				ActiveTracks[Character] = nil
			end
		end)
	else
		print("animation stopped")
	end
end

export type AnimationController = typeof(AnimationController)
return AnimationController
