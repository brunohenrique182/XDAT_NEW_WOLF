package p509

import acmi.l2.clientmod.util.IOEntity
import acmi.l2.clientmod.util.Type
import acmi.l2.clientmod.util.defaultio.DefaultIO
import groovy.beans.Bindable

/**
 * Modern RichListCtrl, present in post-Death-Knight XDAT layouts.
 *
 * Reconstructed from hundreds of occurrences in the supplied Wolf Interface.xdat.
 * The semantic names are intentionally left unknown; the binary structure is
 * preserved for safe reading/writing while reverse engineering continues.
 */
@Bindable
class RichListCtrl extends DefaultProperty {
    int modern01
    int modern02
    int modern03
    int modern04
    int modern05
    int modern06
    int modern07
    int modern08
    int modern09
    int modern10
    int modern11
    int modern12
    int modern13

    String modernString = ''

    @Type(RichListElement.class)
    List<RichListElement> values = []

    @Bindable
    @DefaultIO
    static class RichListElement implements IOEntity {
        int value01
        int value02
        int value03
        int value04
        int value05
        int value06
        int value07
        int value08
        int value09
        int value10

        @Override
        String toString() { getClass().simpleName }
    }

    @Override
    RichListCtrl read(InputStream input) {
        super.read(input)

        modern01 = input.readInt()
        modern02 = input.readInt()
        modern03 = input.readInt()
        modern04 = input.readInt()
        modern05 = input.readInt()
        modern06 = input.readInt()
        modern07 = input.readInt()
        modern08 = input.readInt()
        modern09 = input.readInt()
        modern10 = input.readInt()
        modern11 = input.readInt()
        modern12 = input.readInt()
        modern13 = input.readInt()

        modernString = input.readString()
        values = input.readList(RichListElement)
        this
    }

    @Override
    RichListCtrl write(OutputStream output) {
        super.write(output)

        output.writeInt(modern01)
        output.writeInt(modern02)
        output.writeInt(modern03)
        output.writeInt(modern04)
        output.writeInt(modern05)
        output.writeInt(modern06)
        output.writeInt(modern07)
        output.writeInt(modern08)
        output.writeInt(modern09)
        output.writeInt(modern10)
        output.writeInt(modern11)
        output.writeInt(modern12)
        output.writeInt(modern13)

        output.writeString(modernString)
        output.writeList(values)
        this
    }
}
