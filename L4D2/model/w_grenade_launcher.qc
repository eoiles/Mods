// Created by Crowbar 0.71

$modelname "w_models\Weapons\w_grenade_launcher.mdl"

$bodygroup "body"
{
	studio "w_grenade_launcher_reference.smd"
}


$surfaceprop "weapon"

$contents "solid"

$illumposition 0.13 4.341 6.502

$cdmaterials "models\v_models\weapons\grenade_launcher\"

$cbox 0 0 0 0 0 0

$bbox -22.295 -0.912 -5.555 19.88 0.889 16.148

$definebone "ValveBiped.Bip01_R_Hand" "" -0.678223 13.179689 4.585938 9.999761 -89.983228 -179.811383 0 0 0 0 0 0


$sequence "idle" {
	"w_grenade_launcher_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 1
	loop
}

$collisionmodel "w_grenade_launcher_physics.smd"
{
	$mass 10
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}
