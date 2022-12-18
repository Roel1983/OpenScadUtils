include <Optional.inc>
use <Units.scad>

UNITS_DEFAULT_NOZZLE = mm(0.4);
UNITS_DEFAULT_LAYER  = mm(0.15);

function mm(mm)    = mm;
function cm(cm)    = cm * mm(10);
function dm(dm)    = dm * mm(100);
function  m(m)     = m  * mm(1000);

function inch(inch) = inch * cm(25.4);
function mill(mill) = mill * inch(0.001);

function nozzle(nozzle) = nozzle * optional(UNITS_NOZZLE, UNITS_DEFAULT_NOZZLE);
function layer(layer)   = layer  * optional(UNITS_LAYER, UNITS_DEFAULT_LAYER);

function degree(x) = x;
function radian(x) = x / PI * degree(180);
