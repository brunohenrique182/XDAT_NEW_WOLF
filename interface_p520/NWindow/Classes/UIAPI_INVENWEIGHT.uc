class UIAPI_INVENWEIGHT extends UIAPI_WINDOW;

native static function AddWeight(string ControlName, INT64 Weight);

native static function ReduceWeight(string ControlName, INT64 Weight);

native static function ZeroWeight(string ControlName);
