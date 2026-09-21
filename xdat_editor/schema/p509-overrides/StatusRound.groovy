package p509

import acmi.l2.clientmod.l2resources.Tex
import acmi.l2.clientmod.util.IOEntity
import acmi.l2.clientmod.util.Type
import acmi.l2.clientmod.util.defaultio.DefaultIO
import groovy.beans.Bindable
import groovy.transform.CompileDynamic

/**
 * Wolf Waker / p520 StatusRound.
 *
 * Reconstructed from all 25 StatusRound instances in the supplied Interface.xdat
 * and cross-checked with NWindow.StatusBaseHandle.StatusRoundSplitType.
 *
 * p520 serializes six fixed gauge segments:
 * Back, Main, Trailer, Mask1, Mask2 and Overlay.
 * They are followed by two preserved 4-value geometry blocks.
 */
@Bindable
@CompileDynamic
class StatusRound extends DefaultProperty {
    @Type(GaugeTextureSplitData.class)
    List<GaugeTextureSplitData> gaugeSplits = []

    // Two four-value blocks. Keep raw 32-bit values for exact round-trip until
    // their individual semantic names are confirmed.
    int geometry01
    int geometry02
    int geometry03
    int geometry04
    int geometry05
    int geometry06
    int geometry07
    int geometry08

    @Bindable
    @DefaultIO
    static class GaugeTextureSplitData implements IOEntity {
        @Tex String texture = 'undefined'
        int barUSize
        int barVSize
        int color
        int ratio = -9999

        @Override
        String toString() { getClass().simpleName }
    }

    @Override
    StatusRound read(InputStream input) {
        super.read(input)

        gaugeSplits = []
        for (int i = 0; i < 6; i++) {
            GaugeTextureSplitData split = new GaugeTextureSplitData()
            split.texture = input.readString()
            split.barUSize = input.readInt()
            split.barVSize = input.readInt()
            split.color = input.readInt()
            split.ratio = input.readInt()
            gaugeSplits.add(split)
        }

        geometry01 = input.readInt()
        geometry02 = input.readInt()
        geometry03 = input.readInt()
        geometry04 = input.readInt()
        geometry05 = input.readInt()
        geometry06 = input.readInt()
        geometry07 = input.readInt()
        geometry08 = input.readInt()

        this
    }

    @Override
    StatusRound write(OutputStream output) {
        super.write(output)

        if (gaugeSplits == null || gaugeSplits.size() != 6) {
            throw new IOException("p520 StatusRound requires exactly 6 gauge texture split records")
        }

        gaugeSplits.each { GaugeTextureSplitData split ->
            output.writeString(split.texture)
            output.writeInt(split.barUSize)
            output.writeInt(split.barVSize)
            output.writeInt(split.color)
            output.writeInt(split.ratio)
        }

        output.writeInt(geometry01)
        output.writeInt(geometry02)
        output.writeInt(geometry03)
        output.writeInt(geometry04)
        output.writeInt(geometry05)
        output.writeInt(geometry06)
        output.writeInt(geometry07)
        output.writeInt(geometry08)

        this
    }
}
