package p509

import acmi.l2.clientmod.l2resources.Sysstr
import acmi.l2.clientmod.util.IOEntity
import acmi.l2.clientmod.util.Type
import acmi.l2.clientmod.util.defaultio.DefaultIO
import groovy.beans.Bindable

/**
 * Wolf Waker / p520 ListCtrl.
 *
 * Binary-validated against 126 ListCtrl instances in the supplied Interface.xdat.
 * After the legacy ListElement list, p520 adds:
 *   String + 4 ints + a second variable-length ListElement list.
 *
 * The second list is important: controls such as TeamRedList/TeamBlueList carry
 * two columns, while other ListCtrls carry one, three, four, etc.
 */
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
    int modernFlag01
    int modernFlag02
    int modernFlag03
    int modernFlag04

    @Type(ListElement.class)
    List<ListElement> modernColumns = []

    // p520 conditionally appends one fixed ListElement after modernColumns.
    // Confirmed byte-for-byte on GMFindTreeWnd.ListFindWnd in both supplied
    // Interface.xdat and InterfaceClassic.xdat when modernFlag04 != 0.
    ListElement modernTrailingColumn = new ListElement()

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
        modernFlag01 = input.readInt()
        modernFlag02 = input.readInt()
        modernFlag03 = input.readInt()
        modernFlag04 = input.readInt()

        modernColumns = input.readList(ListElement)

        if (modernFlag04 != 0)
            modernTrailingColumn = new ListElement().read(input)

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
        output.writeInt(modernFlag01)
        output.writeInt(modernFlag02)
        output.writeInt(modernFlag03)
        output.writeInt(modernFlag04)

        output.writeList(modernColumns)

        if (modernFlag04 != 0)
            modernTrailingColumn.write(output)

        this
    }
}
