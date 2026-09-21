package p509

import acmi.l2.clientmod.util.IOEntity
import acmi.l2.clientmod.util.Type
import acmi.l2.clientmod.util.defaultio.DefaultIO
import groovy.beans.Bindable

/**
 * Wolf Waker / p520 RichListCtrl.
 *
 * Reconstructed from 225 real RichListCtrl instances in the supplied
 * Interface.xdat and cross-checked with interface_p520 RichListCtrlHandle.
 *
 * Binary layout after DefaultProperty:
 *   11 x int
 *   3 x String
 *   3 x raw byte
 *   3 x String
 *   int columnCount
 *   columnCount x RichListColumn (10 x int)
 *
 * The three raw bytes are normally 0/0/0. Quest-style lists use 16/16/15.
 * Keeping unknown fields raw preserves exact round-trip behavior.
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

    String modernString01 = ''
    String modernString02 = ''
    String modernString03 = ''

    int modernByte01
    int modernByte02
    int modernByte03

    String modernString04 = ''
    String modernString05 = ''
    String modernString06 = ''

    @Type(RichListColumn.class)
    List<RichListColumn> columns = []

    @Bindable
    @DefaultIO
    static class RichListColumn implements IOEntity {
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

        modernString01 = input.readString()
        modernString02 = input.readString()
        modernString03 = input.readString()

        modernByte01 = input.read()
        modernByte02 = input.read()
        modernByte03 = input.read()
        if (modernByte01 < 0 || modernByte02 < 0 || modernByte03 < 0) {
            throw new EOFException("Unexpected EOF inside p520 RichListCtrl byte fields")
        }

        modernString04 = input.readString()
        modernString05 = input.readString()
        modernString06 = input.readString()

        int columnCount = input.readInt()
        if (columnCount < 0 || columnCount > 256) {
            throw new IOException("p520 RichListCtrl invalid column count: " + columnCount)
        }

        columns = []
        for (int i = 0; i < columnCount; i++) {
            RichListColumn column = new RichListColumn()
            column.read(input)
            columns.add(column)
        }

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

        output.writeString(modernString01)
        output.writeString(modernString02)
        output.writeString(modernString03)

        output.write(modernByte01 & 0xff)
        output.write(modernByte02 & 0xff)
        output.write(modernByte03 & 0xff)

        output.writeString(modernString04)
        output.writeString(modernString05)
        output.writeString(modernString06)

        output.writeInt(columns == null ? 0 : columns.size())
        if (columns != null) {
            columns.each { RichListColumn column ->
                column.write(output)
            }
        }

        this
    }
}
