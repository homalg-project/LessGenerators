# SPDX-License-Identifier: GPL-2.0-or-later
# LessGenerators: Find smaller generating sets for modules
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
SetPackageInfo( rec(

PackageName := "LessGenerators",
Subtitle := "Find smaller generating sets for modules",
Version := "2022.07-01",

Date := ~.Version{[ 1 .. 10 ]},
Date := Concatenation( "01/", ~.Version{[ 6, 7 ]}, "/", ~.Version{[ 1 .. 4 ]} ),
License := "GPL-2.0-or-later",

Persons := [
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Mohamed",
    LastName := "Barakat",
    WWWHome := "https://mohamed-barakat.github.io/",
    Email := "mohamed.barakat@uni-siegen.de",
    PostalAddress := Concatenation(
               "Walter-Flex-Str. 3\n",
               "57068 Siegen\n",
               "Germany" ),
    Place := "Siegen",
    Institution := "University of Siegen",
  ),
  rec(
    LastName      := "Fabiańska",
    FirstNames    := "Anna",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "fabianska@momo.math.rwth-aachen.de",
    WWWHome       := "http://wwwb.math.rwth-aachen.de/~fabianska/",
    PostalAddress := Concatenation( [
                       "Lehrstuhl B fuer Mathematik, RWTH Aachen\n",
                       "Templergraben 64\n",
                       "52062 Aachen\n",
                       "Germany" ] ),
    Place         := "Aachen",
    Institution   := "RWTH Aachen University"
  ),
  rec(
    LastName      := "Wagh",
    FirstNames    := "Vinay",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "waghoba@gmail.com",
    WWWHome       := "http://www.iitg.ernet.in/vinay.wagh/",
    PostalAddress := Concatenation( [
                       "E-102, Department of Mathematics,\n",
                       "Indian Institute of Technology Guwahati,\n",
                       "Guwahati, Assam, India.\n",
                       "PIN: 781 039.\n",
                       "India" ] ),
    Place         := "Guwahati",
    Institution   := "Indian Institute of Technology Guwahati"
  ),
],

# BEGIN URLS
SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/homalg-project/LessGenerators",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := "https://homalg-project.github.io/pkg/LessGenerators",
PackageInfoURL  := "https://homalg-project.github.io/LessGenerators/PackageInfo.g",
README_URL      := "https://homalg-project.github.io/LessGenerators/README.md",
ArchiveURL      := Concatenation( "https://github.com/homalg-project/LessGenerators/releases/download/v", ~.Version, "/LessGenerators-", ~.Version ),
# END URLS

ArchiveFormats := ".tar.gz .zip",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "dev",

AbstractHTML   :=  "",

PackageDoc := rec(
  BookName  := "LessGenerators",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Find smaller generating sets for modules",
),

Dependencies := rec(
  GAP := ">= 4.11.1",
  NeededOtherPackages := [
                   [ "AutoDoc", ">= 2013.08.07" ],
                   [ "Modules", ">= 2017.06.19" ],
                   [ "homalg", ">= 2012.05.18" ],
                   [ "RingsForHomalg", ">= 2017.06.21" ],
                   [ "LocalizeRingForHomalg", ">= 2013.07.15" ],
                   [ "MatricesForHomalg", ">= 2019.01.04" ],
                   [ "GAPDoc", ">= 1.1" ]
                   ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := function()
        return true;
    end,

TestFile := "tst/testall.g",

Keywords := [ "generators", "minimal set of generators", "heuristics", "Quillen-Suslin" ]

));
