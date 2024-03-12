hb_t = emu.getLabelAddress("hitbox_t")-0x400
hb_x = emu.getLabelAddress("hitbox_x")-0x400
hb_y = emu.getLabelAddress("hitbox_y")-0x400
hb_w = emu.getLabelAddress("hitbox_w")-0x400
hb_h = emu.getLabelAddress("hitbox_h")-0x400
size = hb_y - hb_x - 1

adr_px = emu.getLabelAddress("player_x")
adr_py = emu.getLabelAddress("player_y")

function see_player()
  --Get the emulation state
  state = emu.getState()

  --Get the player x position
  x_adr = emu.getLabelAddress("player_x")
  x = emu.read(x_adr, emu.memType.cpu)
  --Get the player y position
  y_adr = emu.getLabelAddress("player_y")
  y = emu.read(y_adr, emu.memType.cpu)
  
  --Draw a rectangles
  emu.drawString(x,y,"PLAYER",0xFFFFFF,0x000000)
  emu.drawRectangle(x-1, y-1, 3, 3, 0x00FF00, false)
end

function see_bounding_box()
  --Get the emulation state
  state = emu.getState()

  --Get the bounding box position
  x1 = emu.read(emu.getLabelAddress("player_bound_x1"), emu.memType.cpu)
  y1 = emu.read(emu.getLabelAddress("player_bound_y1"), emu.memType.cpu)
  x2 = emu.read(emu.getLabelAddress("player_bound_x2"), emu.memType.cpu)
  y2 = emu.read(emu.getLabelAddress("player_bound_y2"), emu.memType.cpu)
  
  --Draw the bounding box
  emu.drawRectangle(x1, y1, x2-x1, y2-y1, 0x0000FF, false)
end

function atEndFrame()
  see_player()
  see_bounding_box()
  
  px = emu.read(adr_px, emu.memType.cpu)
  py = emu.read(adr_py, emu.memType.cpu)

  for i=0,size do
    t = emu.read(hb_t+i, emu.memType.cpu)
    if t > 0 then
      x = emu.read(hb_x+i, emu.memType.cpuDebug)
      y = emu.read(hb_y+i, emu.memType.cpuDebug)
      w = emu.read(hb_w+i, emu.memType.cpuDebug)
      h = emu.read(hb_h+i, emu.memType.cpuDebug)

      if x > w or y > h then
        c = 0xFF00FF
      else
        c = 0xFF0000
      end
      
      if px >= x and px <= w and py >= y and py <= h then
        c = 0x00FF00
      end

      emu.drawRectangle(x, y, w-x, h-y, c)
      emu.drawString(x, y-8, t, 0xFFFFFF, 0x80000000)
    end
  end
end

emu.addEventCallback(atEndFrame, emu.eventType.endFrame)
emu.displayMessage("Script", "Hitbox")
