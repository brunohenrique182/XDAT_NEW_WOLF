package p509

import groovy.beans.Bindable
import groovy.transform.CompileDynamic

/**
 * Wolf Waker / p520 TextListBox.
 *
 * Validated against all 6 serialized TextListBox controls in the supplied
 * Interface.xdat. p520 keeps the four legacy 32-bit fields and appends three
 * raw bytes. All observed values are 00 00 00.
 */
@Bindable
@CompileDynamic
class TextListBox extends DefaultProperty {
    int maxRow
    int showRow
    int lineGap
    Boolean isShowScroll

    int modernByte01
    int modernByte02
    int modernByte03

    @Override
    TextListBox read(InputStream input) {
        super.read(input)

        maxRow = input.readInt()
        showRow = input.readInt()
        lineGap = input.readInt()
        isShowScroll = input.readBoolean()

        modernByte01 = input.read()
        modernByte02 = input.read()
        modernByte03 = input.read()
        if (modernByte01 < 0 || modernByte02 < 0 || modernByte03 < 0) {
            throw new EOFException("Unexpected EOF inside p520 TextListBox byte fields")
        }

        this
    }

    @Override
    TextListBox write(OutputStream output) {
        super.write(output)

        output.writeInt(maxRow)
        output.writeInt(showRow)
        output.writeInt(lineGap)
        output.writeBoolean(isShowScroll)

        output.write(modernByte01 & 0xff)
        output.write(modernByte02 & 0xff)
        output.write(modernByte03 & 0xff)

        this
    }
}
