package p509

import acmi.l2.clientmod.l2resources.Tex
import acmi.l2.clientmod.util.IOEntity
import acmi.l2.clientmod.util.Type
import acmi.l2.clientmod.util.defaultio.DefaultIO
import groovy.beans.Bindable
import groovy.transform.CompileDynamic

/**
 * Wolf Waker / p520 StatusBar layout.
 *
 * Reconstructed from 124 StatusBar instances in the supplied Interface.xdat
 * and cross-checked with the p520 NWindow StatusBaseHandle split enum.
 *
 * p520 stores 25 fixed gauge texture segments (no array length prefix):
 * Back 0..2, Regen 3..5, Fore 6..8, Overlay 9..11, Warn 12..14,
 * Fore01 15..17, Fore02 18..20, BlockEffect 21..23, Trailer 24.
 */
@Bindable
@CompileDynamic
class StatusBar extends DefaultProperty {
    String title = 'undefined'
    int titleIndex = -9999
    String unit = 'undefined'
    Boolean drawPoint
    int decimalPlace = -1

    @Type(GaugeTextureSplitData.class)
    List<GaugeTextureSplitData> gaugeSplits = []

    @Tex String gaugeFontTextureName = 'undefined'
    int gaugeFontSizeX
    int gaugeFontSizeY

    @Type(ScaleMark.class)
    List<ScaleMark> scaleMarks = []

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

    @Bindable
    @DefaultIO
    static class ScaleMark implements IOEntity {
        @Tex String markTexture = 'undefined'
        int numberOfMarks
        int markWidth
        int markHeight

        @Override
        String toString() { getClass().simpleName }
    }

    @Override
    StatusBar read(InputStream input) {
        super.read(input)

        title = input.readString()
        titleIndex = input.readInt()
        unit = input.readString()
        drawPoint = input.readBoolean()
        decimalPlace = input.readInt()

        gaugeSplits = []
        for (int i = 0; i < 25; i++) {
            GaugeTextureSplitData split = new GaugeTextureSplitData()
            split.texture = input.readString()
            split.barUSize = input.readInt()
            split.barVSize = input.readInt()
            split.color = input.readInt()
            split.ratio = input.readInt()
            gaugeSplits.add(split)
        }

        gaugeFontTextureName = input.readString()
        gaugeFontSizeX = input.readInt()
        gaugeFontSizeY = input.readInt()

        scaleMarks = input.readList(ScaleMark)
        this
    }

    @Override
    StatusBar write(OutputStream output) {
        super.write(output)

        output.writeString(title)
        output.writeInt(titleIndex)
        output.writeString(unit)
        output.writeBoolean(drawPoint)
        output.writeInt(decimalPlace)

        if (gaugeSplits == null || gaugeSplits.size() != 25) {
            throw new IOException("p520 StatusBar requires exactly 25 gauge texture split records")
        }

        gaugeSplits.each { GaugeTextureSplitData split ->
            output.writeString(split.texture)
            output.writeInt(split.barUSize)
            output.writeInt(split.barVSize)
            output.writeInt(split.color)
            output.writeInt(split.ratio)
        }

        output.writeString(gaugeFontTextureName)
        output.writeInt(gaugeFontSizeX)
        output.writeInt(gaugeFontSizeY)

        output.writeList(scaleMarks)
        this
    }
}
