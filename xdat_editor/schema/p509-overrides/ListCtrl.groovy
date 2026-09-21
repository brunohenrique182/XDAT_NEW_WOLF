package p509

import acmi.l2.clientmod.l2resources.Sysstr
import acmi.l2.clientmod.util.IOEntity
import acmi.l2.clientmod.util.Type
import acmi.l2.clientmod.util.defaultio.DefaultIO
import groovy.beans.Bindable

@Bindable
class ListCtrl extends DefaultProperty {
    int maxRow
    int showRow
    Boolean useVScroll
    int contentsHeight
    int headerHeight
    Boolean usePageBrowser
    Boolean useWheelForScroll
    Boolean compareTooltip

    @Type(ListElement.class)
    List<ListElement> values = []

    String modernString = ''
    int modernTail01
    int modernTail02
    int modernTail03
    int modernTail04
    int modernTail05
    int modernTail06
    int modernTail07
    int modernTail08
    int modernTail09
    int modernTail10

    @Bindable
    @DefaultIO
    static class ListElement implements IOEntity {
        @Sysstr int textStringId
        int width
        boolean bAscend
        boolean bClickEnable
        boolean bNumber

        @Override
        String toString() { getClass().simpleName }
    }

    @Override
    ListCtrl read(InputStream input) {
        super.read(input)
        maxRow = input.readInt()
        showRow = input.readInt()
        useVScroll = input.readBoolean()
        contentsHeight = input.readInt()
        headerHeight = input.readInt()
        usePageBrowser = input.readBoolean()
        useWheelForScroll = input.readBoolean()
        compareTooltip = input.readBoolean()
        values = input.readList(ListElement)

        modernString = input.readString()
        modernTail01 = input.readInt()
        modernTail02 = input.readInt()
        modernTail03 = input.readInt()
        modernTail04 = input.readInt()
        modernTail05 = input.readInt()
        modernTail06 = input.readInt()
        modernTail07 = input.readInt()
        modernTail08 = input.readInt()
        modernTail09 = input.readInt()
        modernTail10 = input.readInt()
        this
    }

    @Override
    ListCtrl write(OutputStream output) {
        super.write(output)
        output.writeInt(maxRow)
        output.writeInt(showRow)
        output.writeBoolean(useVScroll)
        output.writeInt(contentsHeight)
        output.writeInt(headerHeight)
        output.writeBoolean(usePageBrowser)
        output.writeBoolean(useWheelForScroll)
        output.writeBoolean(compareTooltip)
        output.writeList(values)

        output.writeString(modernString)
        output.writeInt(modernTail01)
        output.writeInt(modernTail02)
        output.writeInt(modernTail03)
        output.writeInt(modernTail04)
        output.writeInt(modernTail05)
        output.writeInt(modernTail06)
        output.writeInt(modernTail07)
        output.writeInt(modernTail08)
        output.writeInt(modernTail09)
        output.writeInt(modernTail10)
        this
    }
}
