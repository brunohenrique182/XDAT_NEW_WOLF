package p509

import acmi.l2.clientmod.l2resources.Tex
import groovy.beans.Bindable
import groovy.transform.CompileDynamic

/**
 * Wolf Waker / p520 InvenWeight.
 *
 * Validated against 14 genuine InvenWeight instances in the supplied
 * Interface.xdat (DeliverWnd, DetailStatusWnd, InventoryWnd, WarehouseWnd,
 * TradeWnd, PetWnd and others).
 *
 * p520 keeps the etoa5 body and appends three 32-bit values after fontHeight.
 * All observed target values are -9999. They are preserved explicitly for
 * lossless read/write round trips.
 */
@Bindable
@CompileDynamic
class InvenWeight extends DefaultProperty {
    String target
    int textureWidth
    int textureHeight

    @Tex String textureStepLeft
    @Tex String textureStepMid
    @Tex String textureStepRight
    @Tex String textureWarnLeft
    @Tex String textureWarnMid
    @Tex String textureWarnRight
    @Tex String textureAddedLeft
    @Tex String textureAddedMid
    @Tex String textureAddedRight
    @Tex String textureBackLeft
    @Tex String textureBackMid
    @Tex String textureBackRight
    @Tex String gaugeText

    int fontWidth
    int fontHeight

    int modernTail01 = -9999
    int modernTail02 = -9999
    int modernTail03 = -9999

    @Override
    InvenWeight read(InputStream input) {
        super.read(input)

        target = input.readString()
        textureWidth = input.readInt()
        textureHeight = input.readInt()

        textureStepLeft = input.readString()
        textureStepMid = input.readString()
        textureStepRight = input.readString()
        textureWarnLeft = input.readString()
        textureWarnMid = input.readString()
        textureWarnRight = input.readString()
        textureAddedLeft = input.readString()
        textureAddedMid = input.readString()
        textureAddedRight = input.readString()
        textureBackLeft = input.readString()
        textureBackMid = input.readString()
        textureBackRight = input.readString()
        gaugeText = input.readString()

        fontWidth = input.readInt()
        fontHeight = input.readInt()

        modernTail01 = input.readInt()
        modernTail02 = input.readInt()
        modernTail03 = input.readInt()

        this
    }

    @Override
    InvenWeight write(OutputStream output) {
        super.write(output)

        output.writeString(target)
        output.writeInt(textureWidth)
        output.writeInt(textureHeight)

        output.writeString(textureStepLeft)
        output.writeString(textureStepMid)
        output.writeString(textureStepRight)
        output.writeString(textureWarnLeft)
        output.writeString(textureWarnMid)
        output.writeString(textureWarnRight)
        output.writeString(textureAddedLeft)
        output.writeString(textureAddedMid)
        output.writeString(textureAddedRight)
        output.writeString(textureBackLeft)
        output.writeString(textureBackMid)
        output.writeString(textureBackRight)
        output.writeString(gaugeText)

        output.writeInt(fontWidth)
        output.writeInt(fontHeight)

        output.writeInt(modernTail01)
        output.writeInt(modernTail02)
        output.writeInt(modernTail03)

        this
    }
}
