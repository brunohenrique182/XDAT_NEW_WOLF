package p509

import acmi.l2.clientmod.l2resources.Sysstr
import acmi.l2.clientmod.util.IOEntity
import acmi.l2.clientmod.util.Type
import acmi.l2.clientmod.util.defaultio.DefaultIO
import groovy.beans.Bindable

/**
 * Wolf Waker / p520 ComboBox.
 *
 * Validated against 94 ComboBox instances in the supplied Interface.xdat.
 * p520 adds one 32-bit field BEFORE the legacy values list.
 *
 * This matters because empty ComboBoxes looked compatible by coincidence:
 *   modernHead=0, listCount=0
 * while controls such as BoneName_ComboBox contain:
 *   modernHead=25, listCount=0.
 */
@Bindable
class ComboBox extends DefaultProperty {
    int modernHead

    @Type(ComboBoxElement.class)
    List<ComboBoxElement> values = []

    @Bindable
    @DefaultIO
    static class ComboBoxElement implements IOEntity {
        @Sysstr int sysString = -9999
        int systemMsg = -9999
        String text = 'undefined'
        int reserved = -9999

        @Override
        String toString() { getClass().simpleName }
    }

    @Override
    ComboBox read(InputStream input) {
        super.read(input)
        modernHead = input.readInt()
        values = input.readList(ComboBoxElement)
        this
    }

    @Override
    ComboBox write(OutputStream output) {
        super.write(output)
        output.writeInt(modernHead)
        output.writeList(values)
        this
    }
}
