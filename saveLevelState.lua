local State = require("state")
local SelectionList = require("selectionList")
local TextInput = require("textInput")
local Menu = require("menu")
local Map = require("map")
local ConfirmBoxState = require("confirmBoxState")
local MessageBoxState = require("messageBoxState")

local SaveLevelState = {}
SaveLevelState.__index = SaveLevelState
setmetatable(SaveLevelState, State)

function SaveLevelState.create(parent)
	local self = setmetatable(State.create(), SaveLevelState)

	self.inputs = parent.inputs
	self.cursors = parent.cursors
	self.parent = parent

	self.list = self:addComponent(SelectionList.create(178, 133, 200, 6, 21, self))
	self.input = self:addComponent(TextInput.create(178, 307, 200, 24))
	self.input:setActive(true)

	self.menu = self:addComponent(Menu.create(390, 212, 134, 32, 11, self))
	self.menu:addButton("SAVE", "save")
	self.menu:addButton("DELETE", "delete")
	self.menu:addButton("CANCEL", "cancel")

	self:updateFileList()

	return self
end

function SaveLevelState:draw()
	love.graphics.setColor(love.math.colorFromBytes(23, 23, 23, 255))
	love.graphics.rectangle("fill", 142, 96, 415, 271)
	love.graphics.setColor(love.math.colorFromBytes(241, 148, 0, 255))
	love.graphics.rectangle("line", 142.5, 96.5, 415, 271)
	love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 255))
end

function SaveLevelState:updateFileList()
	local items = {}
	local labels = {}
	local files = love.filesystem.getDirectoryItems("usermaps")
	for i,v in ipairs(files) do
		table.insert(items, v)
		table.insert(labels, v:upper())
	end
	self.list:setItems(items, labels)
end

function SaveLevelState:selectionChanged(source)
	self.input:setText(self.list:getSelection():upper())
end

function SaveLevelState:buttonPressed(id, source)
	if id == "save" then
		playSound("quack")
		if love.filesystem.getInfo(self:getFilename()) then
			pushState(ConfirmBoxState.create(self,
				"OVERWRITE " .. self.input:getText():upper() .. "?",
				function()
					local strdata = self.parent.map:pack()
					love.filesystem.write(self:getFilename(), strdata)
					love.timer.sleep(0.25)
					popState()
				end
			))
		else
			local strdata = self.parent.map:pack()
			love.filesystem.write(self:getFilename(), strdata)
			love.timer.sleep(0.25)
			popState()
		end
	elseif id == "delete" then
		playSound("quack")
		if love.filesystem.getInfo(self:getFilename()) then
			pushState(
				ConfirmBoxState.create(self,
				"ARE YOU SURE YOU WANT TO DELETE " .. self.input:getText():upper() .. "?",
				function()
					love.filesystem.remove(self:getFilename())
					self:updateFileList()
				end
			))
		end
	elseif id == "cancel" then
		playSound("quack")
		love.timer.sleep(0.25)
		popState()
	end
end

function SaveLevelState:getFilename()
	return "usermaps/" .. self.input:getText():lower()
end

function SaveLevelState:isTransparent() return true end

return SaveLevelState
