pcall(function() game.CoreGui:FindFirstChild("AnimationSpy"):Destroy() end)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local gui = Instance.new("ScreenGui")
gui.Name = "AnimationSpy"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = game.CoreGui

-- Main Frame with Glassmorphism style
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 280)
frame.Position = UDim2.new(0, 25, 0, 130)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active = true
frame.ClipsDescendants = true
frame.Parent = gui

local frameStroke = Instance.new("UIStroke")
frameStroke.Thickness = 1
frameStroke.Color = Color3.fromRGB(90, 150, 255)
frameStroke.Transparency = 0.6
frameStroke.Parent = frame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local blur = Instance.new("UIBlurEffect")
blur.Parent = frame
blur.Size = 4

-- Draggable Logic with eased movement
do
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		local goal = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = goal}):Play()
	end
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then update(input) end
	end)
end

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BackgroundTransparency = 0.1
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "🎞️ Animation Spy"
titleLabel.Size = UDim2.new(1, -30, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextScaled = true
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(230, 60, 60)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.Text = "✕"
closeBtn.AutoButtonColor = false
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(255, 90, 90)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(230, 60, 60)}):Play()
end)
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Scrollable list for animations
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -55)
scroll.Position = UDim2.new(0, 10, 0, 45)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 8
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ClipsDescendants = true
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

-- Notifications container (bottom right corner)
local notifHolder = Instance.new("Frame")
notifHolder.Size = UDim2.new(0, 300, 1, -50)
notifHolder.Position = UDim2.new(1, -320, 0, 10)
notifHolder.BackgroundTransparency = 1
notifHolder.ZIndex = 30
notifHolder.Parent = gui

local notifLayout = Instance.new("UIListLayout")
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.Padding = UDim.new(0, 10)
notifLayout.Parent = notifHolder

-- Notification function with fade and slide
local function notify(animName, animId)
	local box = Instance.new("Frame")
	box.Size = UDim2.new(0, 280, 0, 0)
	box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	box.BorderSizePixel = 0
	box.BackgroundTransparency = 0.05
	box.ZIndex = 30
	box.Parent = notifHolder

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = box

	local label = Instance.new("TextLabel")
	label.Text = "📋 Copied: " .. animName .. " | " .. animId
	label.Size = UDim2.new(1, -20, 1, 0)
	label.Position = UDim2.new(0, 15, 0, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(230, 230, 230)
	label.TextScaled = true
	label.Font = Enum.Font.GothamSemibold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 31
	label.Parent = box

	-- Animate in
	TweenService:Create(box, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 280, 0, 40), BackgroundTransparency = 0}):Play()

	task.delay(3, function()
		-- Animate out
		TweenService:Create(box, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 280, 0, 0), BackgroundTransparency = 1}):Play()
		task.wait(0.3)
		box:Destroy()
	end)
end

local seen = {}

local function addAnim(name, id)
	if seen[id] then return end
	seen[id] = true

	local item = Instance.new("Frame")
	item.Size = UDim2.new(1, 0, 0, 40)
	item.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
	item.BorderSizePixel = 0
	item.ClipsDescendants = true
	item.Parent = scroll

	local itemCorner = Instance.new("UICorner")
	itemCorner.CornerRadius = UDim.new(0, 10)
	itemCorner.Parent = item

	local label = Instance.new("TextLabel")
	label.Text = name .. " | " .. id
	label.Size = UDim2.new(0.7, -10, 1, 0)
	label.Position = UDim2.new(0, 15, 0, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.TextScaled = true
	label.Font = Enum.Font.GothamSemibold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = item

	local copyBtn = Instance.new("TextButton")
	copyBtn.Text = "📋"
	copyBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
	copyBtn.Position = UDim2.new(0.7, 5, 0.15, 0)
	copyBtn.BackgroundColor3 = Color3.fromRGB(75, 140, 255)
	copyBtn.TextColor3 = Color3.new(1, 1, 1)
	copyBtn.Font = Enum.Font.GothamBold
	copyBtn.TextScaled = true
	copyBtn.AutoButtonColor = false
	copyBtn.Parent = item

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = copyBtn

	-- Hover effect for copy button
	copyBtn.MouseEnter:Connect(function()
		TweenService:Create(copyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(95, 160, 255)}):Play()
	end)
	copyBtn.MouseLeave:Connect(function()
		TweenService:Create(copyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(75, 140, 255)}):Play()
	end)

	-- Click animation & copy logic
	copyBtn.MouseButton1Click:Connect(function()
		setclipboard("rbxassetid://" .. id)
		notify(name, id)

		-- Brief flash animation on click
		TweenService:Create(item, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(105, 180, 255)}):Play()
		task.wait(0.15)
		TweenService:Create(item, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(38, 38, 38)}):Play()
	end)

	-- Animate item fade-in and slide from left
	item.Position = UDim2.new(0, -320, item.Position.Y.Scale, item.Position.Y.Offset)
	item.BackgroundTransparency = 1
	TweenService:Create(item, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 0, item.Position.Y.Scale, item.Position.Y.Offset),
		BackgroundTransparency = 0,
	}):Play()
end

-- Replace this with your desired target username
local targetName = "GeekyMain"
local plr = game.Players:FindFirstChild(targetName)

if plr then
	local function onChar(char)
		local hum = char:WaitForChild("Humanoid")
		local animConnection

		animConnection = RunService.Heartbeat:Connect(function()
			for _, track in pairs(hum:GetPlayingAnimationTracks()) do
				local animId = track.Animation.AnimationId:match("%d+")
				if animId then
					addAnim(track.Name, animId)
				end
			end
		end)

		-- Disconnect when character dies to avoid memory leaks
		char:WaitForChild("Humanoid").Died:Connect(function()
			if animConnection then
				animConnection:Disconnect()
			end
		end)
	end

	if plr.Character then onChar(plr.Character) end
	plr.CharacterAdded:Connect(onChar)
else
	warn("AnimationSpy: Target player '"..targetName.."' not found.")
end
