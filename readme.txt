Introduction
-------------------------------------------------------------------------------------------------------------
This uberasm tool + patch ASM resource allows you to keep the vanilla powerup/damage system and still have
a health system per-level.

Yes, I did made another health system that there are already others being made on the patch section
(including my own take: https://www.smwcentral.net/?p=section&a=details&id=18149 ). But the reason
why I develop this is because of the rise of kaizo hacks. Most of these types of hacks always make the
player small and die in one hit 99% of the time during platforming/puzzle, and is compensated via multiple
checkpoints.

But in certain situations, such as a boss fight, you probably wanted a health system for the player.

Installation
-------------------------------------------------------------------------------------------------------------
-Recommended resources
--Various status bar patches. Recommended to use the super status bar patch:
  https://www.smwcentral.net/?p=section&a=details&id=19247

-ASM stuff
--Make any necessary changes in the defines files. If you later decide to make further changes
  mid-development on your hack, you must update every copy of that define files.
--Install the aptly named and commented resources in your game. The defines folder must be located in these
  locations:
---For patching via asar, keep the defines where it is originally at
---For uberasm tool, a copy of the folder must be located at the same directory as the uberasm tool exe file
   is at (not in any folders within)
-LM stuff
--You only need to insert the graphic for LG1 (status bar) if...
---You are using the repeated icons display (icons for filled and empty)
---You set it to display numerically and displaying both the current and max HP ("/" character).