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
  emu.drawRectangle(x-1, y-1, 3, 3, 0xFF0000, false)
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
  emu.drawRectangle(x1, y1, x2-x1, y2-y1, 0xFF0000, false)
end

function end_frame()
  see_player()
  see_bounding_box()
end


emu.displayMessage("Player", "Run script")

--Register some code (see_player function) that will be run at the end of each frame
emu.addEventCallback(end_frame, emu.eventType.endFrame)
