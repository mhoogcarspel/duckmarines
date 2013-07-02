Cursor = {}
Cursor.__index = Cursor

function Cursor.create(x,y,player)
	local self = setmetatable({}, Cursor)

	self.x, self.y = x,y
	self.player = player
	local img = ResMgr.getImage("cursor"..player..".png")
	self.sprite = Sprite.create(img)
	self.sprite:setOffset(2, 2)

	return self
end

--- Moves cursor 
-- @param dx Movement on x-axis
-- @param dy Movement on y-axis
-- @param absolute True if coordinates are absolute, not relative
function Cursor:move(dx, dy, absolute)
	if absolute == true then
		self.x = dx
		self.y = dy
	else
		self.x = self.x + dx
		self.y = self.y + dy
	end

	self.x = math.cap(self.x, 0, 562)
	self.y = math.cap(self.y, 0, 422)
end

function Cursor:getDrawable()
	return self.sprite
end