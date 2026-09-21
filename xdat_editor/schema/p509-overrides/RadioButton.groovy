package p509

import acmi.l2.clientmod.l2resources.Sysstr
import acmi.l2.clientmod.util.IOUtil
import acmi.l2.clientmod.util.defaultio.DefaultIO
import groovy.beans.Bindable
import groovy.transform.CompileDynamic

/**
 * Wolf Waker / p520 RadioButton.
 *
 * Binary-validated against all 16 RadioButton instances in the supplied
 * Interface.xdat. p520 appends one int after the legacy etoa5 layout.
 */
@Bindable
@DefaultIO
@CompileDynamic
class RadioButton extends DefaultProperty {
    @Sysstr
    int sysstring
    String text
    int radioGroupID
    Boolean isChecked

    // p520 trailing field. Observed values are -9999 on petition feedback
    // controls and 4 on Search_Window radio buttons.
    int modernTrailingValue

    // @formatter:off
    @Deprecated int getUnk100() { sysstring }
    @Deprecated void setUnk100(int unk100) { this.sysstring = unk100 }

    @Deprecated int getUnk101() { radioGroupID }
    @Deprecated void setUnk101(int unk101) { this.radioGroupID = unk101 }

    @Deprecated int getUnk102() { IOUtil.boolToInt(isChecked) }
    @Deprecated void setUnk102(int unk102) { this.isChecked = IOUtil.intToBool(unk102) }
    // @formatter:on
}
