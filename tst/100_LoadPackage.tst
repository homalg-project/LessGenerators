# SPDX-License-Identifier: GPL-2.0-or-later
# LessGenerators: Find smaller generating sets for modules
#
# This file tests if the package can be loaded without errors or warnings.
#
gap> package_loading_info_level := InfoLevel( InfoPackageLoading );;
gap> SetInfoLevel( InfoPackageLoading, PACKAGE_ERROR );;
gap> LoadPackage( "LessGenerators", false );
true
gap> LoadPackage( "IO_ForHomalg", false );
true
gap> SetInfoLevel( InfoPackageLoading, PACKAGE_INFO );;
gap> LoadPackage( "LessGenerators" );
true
gap> LoadPackage( "IO_ForHomalg" );
true
gap> SetInfoLevel( InfoPackageLoading, package_loading_info_level );;
gap> HOMALG_IO.show_banners := false;;
