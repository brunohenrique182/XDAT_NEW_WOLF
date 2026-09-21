package p509

import acmi.l2.clientmod.l2resources.Tex
import acmi.l2.clientmod.util.IOEntity
import acmi.l2.clientmod.util.StringValue
import acmi.l2.clientmod.util.Type
import acmi.l2.clientmod.util.defaultio.DefaultIO
import groovy.beans.Bindable

/**
 * Wolf/p509 ItemWindow layout reconstructed from the supplied Interface.xdat.
 *
 * Confirmed differences vs etoa5:
 * - one extra 32-bit field after compareTooltip and before outLineUp;
 * - five extra 32-bit fields after expandItem.
 *
 * Unknown fields are preserved losslessly until their semantics are known.
 */
@Bindable
class ItemWindow extends DefaultProperty {
    ItemWindowType wndType = ItemWindowType.ScrollType
    int col
    int row
    int maxItemNum
    int iconWidth
    int iconHeight
    int gapX = -9999
    int gapY = -9999
    int offsetX = -9999
    int offsetY = -9999
    int backgroundItemWidth = -9999
    int backgroundItemHeight = -9999
    @Tex String backgroundItemTex = 'undefined'
    int selectedItemWidth = -9999
    int selectedItemHeight = -9999
    @Tex String selectedItemTex = 'undefined'
    int unselectedItemWidth = -9999
    int unselectedItemHeight = -9999
    @Tex String unselectedItemTex = 'undefined'
    int newToggleItemOffSetX = -9999
    int newToggleItemOffSetY = -9999
    int newToggleItemWidth = -9999
    int newToggleItemHeight = -9999
    @Tex String newToggleItemTex = 'undefined'
    int blankItemWidth = -9999
    int blankItemHeight = -9999
    @Tex String blankItemTex = 'undefined'
    int blankItemDependency = 0
    Boolean noSelectItem
    Boolean noItemDrag
    Boolean buttonClick
    Boolean useCoolTime
    Boolean noScroll
    Boolean showIconFrame
    Boolean simpleTooltip
    Boolean compareTooltip

    int modernFlags01 = -1

    @Tex String outLineUp = 'l2ui_ch3.InventoryWnd.inventory_outline'
    @Tex String outLineDown = 'l2ui_ch3.InventoryWnd.inventory_outline_down'
    int buttonTypePrevButtonPosX = -9999
    int buttonTypePrevButtonPosY = -9999
    int buttonTypeNextButtonPosX = -9999
    int buttonTypeNextButtonPosY = -9999

    @Type(ItemWindowInner.class)
    List<ItemWindowInner> expandItem = []

    int modernTail01
    int modernTail02
    int modernTail03
    int modernTail04
    int modernTail05

    @Bindable
    @DefaultIO
    static class ItemWindowInner implements IOEntity {
        int width
        int height
        int num
        @Tex String texture

        @Override
        String toString() { getClass().simpleName }
    }

    enum ItemWindowType implements StringValue {
        ScrollType,
        SideButtonType,
        UpDownButtonType
    }

    @Override
    ItemWindow read(InputStream input) {
        super.read(input)

        wndType = input.readEnum(ItemWindowType)
        col = input.readInt()
        row = input.readInt()
        maxItemNum = input.readInt()
        iconWidth = input.readInt()
        iconHeight = input.readInt()
        gapX = input.readInt()
        gapY = input.readInt()
        offsetX = input.readInt()
        offsetY = input.readInt()
        backgroundItemWidth = input.readInt()
        backgroundItemHeight = input.readInt()
        backgroundItemTex = input.readString()
        selectedItemWidth = input.readInt()
        selectedItemHeight = input.readInt()
        selectedItemTex = input.readString()
        unselectedItemWidth = input.readInt()
        unselectedItemHeight = input.readInt()
        unselectedItemTex = input.readString()
        newToggleItemOffSetX = input.readInt()
        newToggleItemOffSetY = input.readInt()
        newToggleItemWidth = input.readInt()
        newToggleItemHeight = input.readInt()
        newToggleItemTex = input.readString()
        blankItemWidth = input.readInt()
        blankItemHeight = input.readInt()
        blankItemTex = input.readString()
        blankItemDependency = input.readInt()
        noSelectItem = input.readBoolean()
        noItemDrag = input.readBoolean()
        buttonClick = input.readBoolean()
        useCoolTime = input.readBoolean()
        noScroll = input.readBoolean()
        showIconFrame = input.readBoolean()
        simpleTooltip = input.readBoolean()
        compareTooltip = input.readBoolean()

        modernFlags01 = input.readInt()

        outLineUp = input.readString()
        outLineDown = input.readString()
        buttonTypePrevButtonPosX = input.readInt()
        buttonTypePrevButtonPosY = input.readInt()
        buttonTypeNextButtonPosX = input.readInt()
        buttonTypeNextButtonPosY = input.readInt()
        expandItem = input.readList(ItemWindowInner)

        modernTail01 = input.readInt()
        modernTail02 = input.readInt()
        modernTail03 = input.readInt()
        modernTail04 = input.readInt()
        modernTail05 = input.readInt()

        this
    }

    @Override
    ItemWindow write(OutputStream output) {
        super.write(output)

        output.writeEnum(wndType)
        output.writeInt(col)
        output.writeInt(row)
        output.writeInt(maxItemNum)
        output.writeInt(iconWidth)
        output.writeInt(iconHeight)
        output.writeInt(gapX)
        output.writeInt(gapY)
        output.writeInt(offsetX)
        output.writeInt(offsetY)
        output.writeInt(backgroundItemWidth)
        output.writeInt(backgroundItemHeight)
        output.writeString(backgroundItemTex)
        output.writeInt(selectedItemWidth)
        output.writeInt(selectedItemHeight)
        output.writeString(selectedItemTex)
        output.writeInt(unselectedItemWidth)
        output.writeInt(unselectedItemHeight)
        output.writeString(unselectedItemTex)
        output.writeInt(newToggleItemOffSetX)
        output.writeInt(newToggleItemOffSetY)
        output.writeInt(newToggleItemWidth)
        output.writeInt(newToggleItemHeight)
        output.writeString(newToggleItemTex)
        output.writeInt(blankItemWidth)
        output.writeInt(blankItemHeight)
        output.writeString(blankItemTex)
        output.writeInt(blankItemDependency)
        output.writeBoolean(noSelectItem)
        output.writeBoolean(noItemDrag)
        output.writeBoolean(buttonClick)
        output.writeBoolean(useCoolTime)
        output.writeBoolean(noScroll)
        output.writeBoolean(showIconFrame)
        output.writeBoolean(simpleTooltip)
        output.writeBoolean(compareTooltip)

        output.writeInt(modernFlags01)

        output.writeString(outLineUp)
        output.writeString(outLineDown)
        output.writeInt(buttonTypePrevButtonPosX)
        output.writeInt(buttonTypePrevButtonPosY)
        output.writeInt(buttonTypeNextButtonPosX)
        output.writeInt(buttonTypeNextButtonPosY)
        output.writeList(expandItem)

        output.writeInt(modernTail01)
        output.writeInt(modernTail02)
        output.writeInt(modernTail03)
        output.writeInt(modernTail04)
        output.writeInt(modernTail05)

        this
    }
}
