### Brouter-profiles collection

List of end user variants of Trekking-Poutnik bike profile template for Brouter routing application (Android standalone + 3rd party routing modul for OSMAnd/Locus/Oruxmaps https://play.google.com/store/apps/details?id=btools.routingapp ).
See aslo http://brouter.de/brouter-web/ for online web planner/ profile tester
-----------------------------------------
Trekking Dry is my default trekking profile, being identical to default configuration of Trekking-Poutnik.brf template. It has multiple enhancement wrt reference Trekking.brf.

Trekking Wet is modification of above , penalizing muddy / slicky surfaces.

Trekking MTBs are not really intended to MTB, but rather making trekking routes more MTB-like. They involve MTB_factor,
 progressively promoting - penalizing from unpaved surfaces to mainroads ( penalties -0.2..0.2 for light, -0.5..0.5 for medium, -1.0..1.0 for Strong. Additionally it partialy cancels roughness penalty.

Hiking Beta is still under development, involving wet modes and MTP + SAC difficulty scales. I got a feedback it seems quite useable.

For profile template development, see repositories

https://github.com/poutnikl/Trekking-Poutnik

https://github.com/poutnikl/Hiking-Poutnik

