// Created by Crowbar 0.71

$modelname "v_models\v_grenade_launcher.mdl"

$bodygroup "grenade_launcher"
{
	studio "v_grenade_launcher_reference.smd"
}
$bodygroup "arms"
{
	studio "v_arms_mechanic_new_reference.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition -0.743 -9.472 -31.982

$cdmaterials "models\v_models\Weapons\grenade_launcher\"
$cdmaterials "models\survivors\mechanic\"

$attachment "flashlight" "ValveBiped.weapon_bolt" 0.04 -2.45 15.8 rotate -83.74 -90 90
$attachment "attach_shell_eject" "ValveBiped.attach_shell_eject" 0 0 0 rotate 0 0 0
$attachment "attach_muzzle" "ValveBiped.attach_muzzle" 0 0 0 rotate 0 0 0
$attachment "muzzle_flash" "ValveBiped.weapon_bone" 0 3.91 38.47 rotate -90 0 0
$attachment "shell" "ValveBiped.weapon_bone" -0.4 3.41 8.66 rotate 1.01 170.47 179.83
$attachment "attach_camera" "ValveBiped.attach_camera" 0 0 0 rotate 0 0 0
$attachment "camera" "ValveBiped.Camera" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -10.48 -6.862 -64 33.648 4.931 1.63

$definebone "ValveBiped.ValveBiped" "" 0 0 0 0 0 89.999982 0 0 0 0 0 0
$definebone "ValveBiped.Bip01" "ValveBiped.ValveBiped" 0 37.739231 -0.516773 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.Camera" "ValveBiped.ValveBiped" 0 56.084805 0 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.weapon_bone" "ValveBiped.Bip01" 8.329032 7.655514 0 -89.999982 -89.745988 0 0 0 0 0 0 0
$definebone "ValveBiped.attach_muzzle" "ValveBiped.weapon_bone" 0 0.099715 8.360889 -89.999982 0 0 0 0 0 0 0 0
$definebone "ValveBiped.attach_shell_eject" "ValveBiped.weapon_bone" 0 3.003861 1.610718 0 89.999982 -89.999982 0 0 0 0 0 0
$definebone "ValveBiped.attach_camera" "ValveBiped.Camera" 0 0 0 -89.999982 0 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Spine" "ValveBiped.Bip01" 0 4.043964 -0.017929 4.766608 89.999982 89.999982 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Spine1" "ValveBiped.Bip01_Spine" 3.995834 0 0 0 -9.852983 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Spine2" "ValveBiped.Bip01_Spine1" 3.698246 -0.000001 0 0 -0.906994 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Spine4" "ValveBiped.Bip01_Spine2" 5.700882 0 0 0 28.371668 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Clavicle" "ValveBiped.Bip01_Spine4" 4.065395 1.458945 1.5 -63.87528 -147.035805 50.277507 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_UpperArm" "ValveBiped.Bip01_L_Clavicle" 5.507357 0.000008 0.000002 -19.730431 -44.165478 -79.348295 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Forearm" "ValveBiped.Bip01_L_UpperArm" 10.907387 0.000001 0 -0.000002 -7.20248 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Hand" "ValveBiped.Bip01_L_Forearm" 10.424316 -0.000006 -0.000031 6.50731 7.122669 78.669798 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger4" "ValveBiped.Bip01_L_Hand" 2.997272 0.005409 -1.477472 8.21335 -12.990157 11.74243 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger41" "ValveBiped.Bip01_L_Finger4" 1.510374 0 0 0.955236 -34.374607 0.653402 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger42" "ValveBiped.Bip01_L_Finger41" 0.808647 -0.000002 0 -10.048531 -17.354261 -3.121073 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger3" "ValveBiped.Bip01_L_Hand" 3.305794 0.203114 -0.546729 5.954122 -16.778211 11.337862 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger31" "ValveBiped.Bip01_L_Finger3" 1.807178 0.000004 0 -5.063457 -30.512986 -2.977605 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger32" "ValveBiped.Bip01_L_Finger31" 0.966137 -0.000001 0 0.559036 -13.904478 0.138369 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger2" "ValveBiped.Bip01_L_Hand" 3.571516 0.109303 0.409579 3.893594 -14.791079 10.730297 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger21" "ValveBiped.Bip01_L_Finger2" 2.150656 0.000002 0 -3.092654 -37.967171 -2.410835 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger22" "ValveBiped.Bip01_L_Finger21" 1.152744 0.000001 0 0.688639 -8.970344 0.108689 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger1" "ValveBiped.Bip01_L_Hand" 3.684093 -0.158699 1.419181 1.961121 -11.693724 10.352721 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger11" "ValveBiped.Bip01_L_Finger1" 1.701008 -0.000002 0 3.66905 -38.756252 2.940821 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger12" "ValveBiped.Bip01_L_Finger11" 0.994705 0.000001 0 2.209324 -1.896554 0.073165 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger0" "ValveBiped.Bip01_L_Hand" 1.068069 -1.287205 0.981903 -19.741837 -7.111208 97.051428 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger01" "ValveBiped.Bip01_L_Finger0" 1.8363 0.000001 -0.000002 -10.778426 -10.615992 -0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger02" "ValveBiped.Bip01_L_Finger01" 1.223949 0 0 -2.328845 11.249052 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Clavicle" "ValveBiped.Bip01_Spine4" 4.065395 1.458947 -1.5 63.87528 -147.03575 -54.583283 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_UpperArm" "ValveBiped.Bip01_R_Clavicle" 5.507363 -0.000008 -0.000002 22.698467 -42.953721 82.694999 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Forearm" "ValveBiped.Bip01_R_UpperArm" 10.907394 0 -0.000008 0.000007 -7.202481 0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "ValveBiped.Bip01_R_Forearm" 10.424297 -0.000006 0.000011 -6.507535 7.12261 -78.876978 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger4" "ValveBiped.Bip01_R_Hand" 2.997297 0.000067 1.477481 -8.213408 -12.989923 -11.535191 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger41" "ValveBiped.Bip01_R_Finger4" 1.510382 0 0 -0.955237 -34.374614 -0.653401 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger42" "ValveBiped.Bip01_R_Finger41" 0.808651 -0.000001 0 10.048532 -17.354339 3.121074 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger3" "ValveBiped.Bip01_R_Hand" 3.305807 0.201136 0.547461 -5.954236 -16.777977 -11.130627 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger31" "ValveBiped.Bip01_R_Finger3" 1.807177 -0.000004 0 5.063455 -30.512986 2.977603 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger32" "ValveBiped.Bip01_R_Finger31" 0.966137 -0.000001 0 -0.559038 -13.904486 -0.13837 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger2" "ValveBiped.Bip01_R_Hand" 3.571527 0.110786 -0.40918 -3.893707 -14.790903 -10.523118 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger21" "ValveBiped.Bip01_R_Finger2" 2.150661 0.000002 0 3.092652 -37.967174 2.410834 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger22" "ValveBiped.Bip01_R_Finger21" 1.152748 0.000001 0 -0.688641 -8.970351 -0.108691 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger1" "ValveBiped.Bip01_R_Hand" 3.684118 -0.153564 -1.419746 -1.961178 -11.69349 -10.145482 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger11" "ValveBiped.Bip01_R_Finger1" 1.701015 0.000002 0 -3.669051 -38.756249 -2.94082 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger12" "ValveBiped.Bip01_R_Finger11" 0.994701 0.000001 0 -2.209325 -1.896547 -0.073166 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger0" "ValveBiped.Bip01_R_Hand" 1.068092 -1.283655 -0.986552 19.767273 -7.037118 -96.83291 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger01" "ValveBiped.Bip01_R_Finger0" 1.836306 -0.000002 0.000002 10.778421 -10.615988 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger02" "ValveBiped.Bip01_R_Finger01" 1.223946 0 0 2.328842 11.249056 0 0 0 0 0 0 0
$definebone "ValveBiped.weapon_charger_slide" "ValveBiped.weapon_bone" 0 1.945635 -1.740829 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.weapon_bolt" "ValveBiped.weapon_bone" 0 1.945635 0 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.weapon_clip" "ValveBiped.weapon_bone" 0 -0.000003 3.857136 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Forearm_driven" "ValveBiped.Bip01_R_Forearm" 3.201996 0 -0.000004 -6.000004 6.999998 -78.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Driven_ulna" "ValveBiped.Bip01_R_Forearm" 6.694 0 -0.000004 -6.01496 7.006011 -78.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_thumbroot" "ValveBiped.Bip01_R_Hand" 0.109997 -0.820999 -0.907 20.664982 -17.516003 -104.52401 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Forearm_driven" "ValveBiped.Bip01_L_Forearm" 3.257999 -0.031001 0.000008 6.000014 6.999998 78.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Driven_ulna" "ValveBiped.Bip01_L_Forearm" 6.867996 0 0.000008 6.000014 6.999998 78.000009 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_thumbroot" "ValveBiped.Bip01_L_Hand" 0.084997 -0.691999 1.011 26.038983 111.969996 -76.420999 0 0 0 0 0 0

$bonemerge "ValveBiped.ValveBiped"
$bonemerge "ValveBiped.Bip01"
$bonemerge "ValveBiped.Camera"
$bonemerge "ValveBiped.weapon_bone"
$bonemerge "ValveBiped.attach_muzzle"
$bonemerge "ValveBiped.attach_shell_eject"
$bonemerge "ValveBiped.attach_camera"
$bonemerge "ValveBiped.Bip01_Spine"
$bonemerge "ValveBiped.Bip01_Spine1"
$bonemerge "ValveBiped.Bip01_Spine2"
$bonemerge "ValveBiped.Bip01_Spine4"
$bonemerge "ValveBiped.Bip01_L_Clavicle"
$bonemerge "ValveBiped.Bip01_L_UpperArm"
$bonemerge "ValveBiped.Bip01_L_Forearm"
$bonemerge "ValveBiped.Bip01_L_Hand"
$bonemerge "ValveBiped.Bip01_L_Finger4"
$bonemerge "ValveBiped.Bip01_L_Finger41"
$bonemerge "ValveBiped.Bip01_L_Finger42"
$bonemerge "ValveBiped.Bip01_L_Finger3"
$bonemerge "ValveBiped.Bip01_L_Finger31"
$bonemerge "ValveBiped.Bip01_L_Finger32"
$bonemerge "ValveBiped.Bip01_L_Finger2"
$bonemerge "ValveBiped.Bip01_L_Finger21"
$bonemerge "ValveBiped.Bip01_L_Finger22"
$bonemerge "ValveBiped.Bip01_L_Finger1"
$bonemerge "ValveBiped.Bip01_L_Finger11"
$bonemerge "ValveBiped.Bip01_L_Finger12"
$bonemerge "ValveBiped.Bip01_L_Finger0"
$bonemerge "ValveBiped.Bip01_L_Finger01"
$bonemerge "ValveBiped.Bip01_L_Finger02"
$bonemerge "ValveBiped.Bip01_R_Clavicle"
$bonemerge "ValveBiped.Bip01_R_UpperArm"
$bonemerge "ValveBiped.Bip01_R_Forearm"
$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "ValveBiped.Bip01_R_Finger4"
$bonemerge "ValveBiped.Bip01_R_Finger41"
$bonemerge "ValveBiped.Bip01_R_Finger42"
$bonemerge "ValveBiped.Bip01_R_Finger3"
$bonemerge "ValveBiped.Bip01_R_Finger31"
$bonemerge "ValveBiped.Bip01_R_Finger32"
$bonemerge "ValveBiped.Bip01_R_Finger2"
$bonemerge "ValveBiped.Bip01_R_Finger21"
$bonemerge "ValveBiped.Bip01_R_Finger22"
$bonemerge "ValveBiped.Bip01_R_Finger1"
$bonemerge "ValveBiped.Bip01_R_Finger11"
$bonemerge "ValveBiped.Bip01_R_Finger12"
$bonemerge "ValveBiped.Bip01_R_Finger0"
$bonemerge "ValveBiped.Bip01_R_Finger01"
$bonemerge "ValveBiped.Bip01_R_Finger02"
$bonemerge "ValveBiped.Bip01_R_Forearm_driven"
$bonemerge "ValveBiped.Bip01_R_Driven_ulna"
$bonemerge "ValveBiped.Bip01_R_thumbroot"
$bonemerge "ValveBiped.Bip01_L_Forearm_driven"
$bonemerge "ValveBiped.Bip01_L_Driven_ulna"
$bonemerge "ValveBiped.Bip01_L_thumbroot"


$sequence "idle" {
	"v_grenade_launcher_anims\idle.smd"
	activity "ACT_VM_IDLE" 1
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "deploy" {
	"v_grenade_launcher_anims\deploy.smd"
	activity "ACT_VM_DRAW" 1
	{ event 5004 1 "GrenadeLauncher.Deploy" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "fire" {
	"v_grenade_launcher_anims\fire.smd"
	activity "ACT_VM_PRIMARYATTACK" 1
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "reload" {
	"v_grenade_launcher_anims\reload.smd"
	activity "ACT_VM_RELOAD" 1
	{ event 5004 7 "GrenadeLauncher.LatchOpen" }
	{ event 5004 30 "GrenadeLauncher.ShellOut" }
	{ event 5004 70 "GrenadeLauncher.ShellIn" }
	{ event 5004 89 "GrenadeLauncher.ActionClosed" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "melee" {
	"v_grenade_launcher_anims\melee.smd"
	activity "ACT_VM_SECONDARYATTACK" 1
	fadein 0.2
	fadeout 0.2
	fps 30
}
