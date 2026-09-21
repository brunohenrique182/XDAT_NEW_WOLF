package p509

import groovy.beans.Bindable
import groovy.transform.CompileDynamic

/**
 * Wolf Waker / p520 TextListBox.
 *
 * Binary-validated against every serialized TextListBox in both supplied p520
 * XDAT files. p520 keeps the four legacy fields and appends three strings used
 * by the vertical scrollbar. Most controls serialize them as three empty
 * strings (00 00 00), while QuestDialogWnd stores the three
 * ScrollAreaVSliderBar texture names.
 */
@Bindable
@CompileDynamic
class TextListBox extends DefaultProperty {
    int maxRow
    int showRow
    int lineGap
    Boolean isShowScroll

    String sliderBarTopTexture = ''
    String sliderBarCenterTexture = ''
    String sliderBarBottomTexture = ''

    @Override
    TextListBox read(InputStream input) {
        super.read(input)

        maxRow = input.readInt()
        showRow = input.readInt()
        lineGap = input.readInt()
        isShowScroll = input.readBoolean()

        sliderBarTopTexture = input.readString()
        sliderBarCenterTexture = input.readString()
        sliderBarBottomTexture = input.readString()

        this
    }

    @Override
    TextListBox write(OutputStream output) {
        super.write(output)

        output.writeInt(maxRow)
        output.writeInt(showRow)
        output.writeInt(lineGap)
        output.writeBoolean(isShowScroll)

        output.writeString(sliderBarTopTexture)
        output.writeString(sliderBarCenterTexture)
        output.writeString(sliderBarBottomTexture)

        this
    }
}
