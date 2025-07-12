
catnip_package(ansnd DEFAULT all)

catnip_add_preset(gamecube
	TOOLSET    GameCube
	BUILD_TYPE Release
)

catnip_add_preset(wii
	TOOLSET    Wii
	BUILD_TYPE Release
)
