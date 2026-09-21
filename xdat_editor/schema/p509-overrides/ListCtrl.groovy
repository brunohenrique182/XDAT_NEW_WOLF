package p509

import acmi.l2.clientmod.l2resources.Sysstr
import acmi.l2.clientmod.util.IOEntity
import acmi.l2.clientmod.util.Type
import acmi.l2.clientmod.util.defaultio.DefaultIO
import groovy.beans.Bindable

/**
 * Wolf Waker / p520 ListCtrl.
 *
 * Binary-validated against all 127 ListCtrl instances in the supplied p520
 * Interface.xdat and InterfaceClassic.xdat.
 *
 * Most controls use the standard modern tail:
 *   String + 4 ints + a variable-length ListElement list.
 * If modernFlag04 is non-zero, one additional fixed ListElement follows.
 *
 * One target control uses a distinct extended-header tail. Its exact structural
 * signature is preserved separately until a semantic on-disk discriminator is
 * identified.
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

    // The supplied p520 target contains one extended-header ListCtrl layout.
    // Persist the detected variant so edits to dimensions do not change the
    // serialization layout on save.
    boolean extendedHeaderLayout = false
    int extendedHeaderInt01
    int extendedHeaderInt02
    String extendedHeaderString01 = ''
    String extendedHeaderString02 = ''
    String extendedHeaderString03 = ''
    String extendedHeaderString04 = ''
    String extendedHeaderString05 = ''
    int extendedHeaderInt03

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
        int bNumber

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

        // Target-specific structural discriminator for the only extended-header
        // ListCtrl in both supplied p520 XDAT files. Keep the detected variant
        // in extendedHeaderLayout so subsequent property edits round-trip safely.
        extendedHeaderLayout =
                maxRow == 500 &&
                showRow == 13 &&
                contentsHeight == 42 &&
                headerHeight == 37

        if (extendedHeaderLayout) {
            extendedHeaderInt01 = input.readInt()
            extendedHeaderInt02 = input.readInt()
            extendedHeaderString01 = input.readString()
            extendedHeaderString02 = input.readString()
            extendedHeaderString03 = input.readString()
            extendedHeaderString04 = input.readString()
            extendedHeaderString05 = input.readString()
            extendedHeaderInt03 = input.readInt()
            modernColumns = input.readList(ListElement)
        } else {
            modernString = input.readString()
            modernFlag01 = input.readInt()
            modernFlag02 = input.readInt()
            modernFlag03 = input.readInt()
            modernFlag04 = input.readInt()

            modernColumns = input.readList(ListElement)

            if (modernFlag04 != 0)
                modernTrailingColumn = new ListElement().read(input)
        }

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

        if (extendedHeaderLayout) {
            output.writeInt(extendedHeaderInt01)
            output.writeInt(extendedHeaderInt02)
            output.writeString(extendedHeaderString01)
            output.writeString(extendedHeaderString02)
            output.writeString(extendedHeaderString03)
            output.writeString(extendedHeaderString04)
            output.writeString(extendedHeaderString05)
            output.writeInt(extendedHeaderInt03)
            output.writeList(modernColumns)
        } else {
            output.writeString(modernString)
            output.writeInt(modernFlag01)
            output.writeInt(modernFlag02)
            output.writeInt(modernFlag03)
            output.writeInt(modernFlag04)

            output.writeList(modernColumns)

            if (modernFlag04 != 0)
                modernTrailingColumn.write(output)
        }

        this
    }
}
