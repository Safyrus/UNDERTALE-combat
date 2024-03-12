
function atEndFrame()
  adr_f = emu.getLabelAddress("anims_flag")
  adr_t = emu.getLabelAddress("anims_type")
  adr_x = emu.getLabelAddress("anims_x")
  adr_y = emu.getLabelAddress("anims_y")
  adr_d = emu.getLabelAddress("anims_delay")
  adr_nl = emu.getLabelAddress("anims_next_lo")
  adr_nh = emu.getLabelAddress("anims_next_hi")
  size = adr_y - adr_x
  for i=0,size do
    f = emu.read(adr_f+i, emu.memType.cpu)
    if (f >> 7) > 0 then
      x = emu.read(adr_x+i, emu.memType.cpu)
      y = emu.read(adr_y+i, emu.memType.cpu)
      d = emu.read(adr_d+i, emu.memType.cpu)
      t = emu.read(adr_t+i, emu.memType.cpu)
      nl = emu.read(adr_nl+i, emu.memType.cpu)
      nh = emu.read(adr_nh+i, emu.memType.cpu)
      if t == 0 then
        c = 0xFF0000
      else
        c = 0x0000FF
      end
      emu.drawRectangle(x, y, 8, 8, c)
      emu.drawString(x, y-8, (nh << 8) + nl .. "|" .. string.format("%02d", d), 0xFFFFFF, 0xC0FFFFFF)
    end
  end
end

emu.addEventCallback(atEndFrame, emu.eventType.endFrame)

emu.displayMessage("Script", "Animation")
