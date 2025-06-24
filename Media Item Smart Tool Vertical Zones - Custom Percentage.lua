-- @description Media Item Smart Tool Vertical Zones - Custom Percentage.lua
-- @version 1.0
-- @date 06.19.25
-- @author seemikedrum
-- @about
-- This script gives similar functionality to ProTools' "Smart Tool."
-- However, instead of splitting the media item into top and bottom halves, this script splits the zones into top 75% and bottom 25% portions.
-- It then automatically switches to the razor select tool when the mouse is hovering over the top 75% of the media item, or the move tool when hovering over the bottom 25%.

-- ===== USER DEFINABLE SETTING =====
DENOMINATOR = 5 -- 4-> the bottom quarter  3 -> bottom third, etc.
-- ===================================

TOP_ACTION = 1
BOTTOM_ACTION = 2
INIT_ACTION = 3

MM_CTX_ITEMLOWER = {}
MM_CTX_ITEMLOWER_CLK = {}
MM_CTX_ITEMLOWER_DBLCLK = {}

function GetTopBottomItemQuarter()
  local itempart
  local x, y = reaper.GetMousePosition()

  local item_under_mouse = reaper.GetItemFromPoint(x, y, true)

  if item_under_mouse then

    local item_h = reaper.GetMediaItemInfo_Value(item_under_mouse, "I_LASTH")

    local test_point = math.floor(y + (item_h - 1) * OScoeff)
    local test_item, take = reaper.GetItemFromPoint(x, test_point, true)

    if item_under_mouse == test_item then
      itempart = "header"
    else
      local test_point = math.floor(y + item_h / DENOMINATOR * OScoeff)
      local test_item, take = reaper.GetItemFromPoint(x, test_point, true)

      if item_under_mouse ~= test_item then
        itempart = "bottom"
      else
        itempart = "top"
      end
    end

    return itempart
  else
    return nil
  end

end

function setAction(action)
  i = 0
  if action == INIT_ACTION then
    while i < 16 do
      MM_CTX_ITEMLOWER[i] = reaper.GetMouseModifier('MM_CTX_ITEMLOWER', i)
      MM_CTX_ITEMLOWER_CLK[i] = reaper.GetMouseModifier('MM_CTX_ITEMLOWER_CLK', i)
      MM_CTX_ITEMLOWER_DBLCLK[i] = reaper.GetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK', i)
      i = i + 1
    end
  elseif action == TOP_ACTION then
    while i < 16 do
      reaper.SetMouseModifier('MM_CTX_ITEMLOWER', i, "0")
      reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK', i, "0")
      reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK', i, "0")
      i = i + 1
    end
  elseif action == BOTTOM_ACTION then
    while i < 16 do
      if i > 0 and MM_CTX_ITEMLOWER[i] == MM_CTX_ITEMLOWER[0] then
        reaper.SetMouseModifier('MM_CTX_ITEMLOWER', i, -1)
      else
        reaper.SetMouseModifier('MM_CTX_ITEMLOWER', i, MM_CTX_ITEMLOWER[i])
      end
      if i > 0 and MM_CTX_ITEMLOWER_CLK[i] == MM_CTX_ITEMLOWER_CLK[0] then
        reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK', i, -1)
      else
        reaper.SetMouseModifier('MM_CTX_ITEMLOWER_CLK', i, MM_CTX_ITEMLOWER_CLK[i])
      end
      if i > 0 and MM_CTX_ITEMLOWER_DBLCLK[i] == MM_CTX_ITEMLOWER_DBLCLK[0] then
        reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK', i, -1)
      else
        reaper.SetMouseModifier('MM_CTX_ITEMLOWER_DBLCLK', i, MM_CTX_ITEMLOWER_DBLCLK[i])
      end
      i = i + 1
    end
  end
end

function main()
  location = GetTopBottomItemQuarter()
  if location == "top" then
    if last_action ~= TOP_ACTION then
      setAction(TOP_ACTION)
      last_action = TOP_ACTION
    end
  else
    if last_action ~= BOTTOM_ACTION then
      setAction(BOTTOM_ACTION)
      last_action = BOTTOM_ACTION
    end
  end
  reaper.defer(main)
end

function exit()
  setAction(BOTTOM_ACTION)
  local is_new_value, filename, sectionID, cmdID, mode, resolution, val = reaper.get_action_context()
  reaper.SetToggleCommandState(sectionID, cmdID, 0)
  reaper.RefreshToolbar2(sectionID, cmdID)
end

local is_new_value, filename, sectionID, cmdID, mode, resolution, val = reaper.get_action_context()
reaper.SetToggleCommandState(sectionID, cmdID, 1)
reaper.RefreshToolbar2(sectionID, cmdID)

reaper.atexit(exit)
OScoeff = 1
if reaper.GetOS():match("^Win") == nil then
  OScoeff = -1
end
setAction(INIT_ACTION)
last_action = INIT_ACTION
main()
