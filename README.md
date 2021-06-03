
# Customizable Cable Raceway and Lid

An OpenSCAD script to generate 3D printable STL files for cable raceways, with matching lids.  Many optional features, including:

* fully parametric width, height, and length
* separate length and width variables for the lid, for more flexibility
* parametric cable slots that maintain static spacing across any length, width, or height of raceway
* optional keyholes to improve cable carrying capacity of each slot without the need to use wider slots
* optional mounting holes along raceway bottom, on user defined centers, starting at a user defined distance from raceway end
* imprinted text on the lid
* able to render just the raceway, just the lid, or both at once for maximum versatility
* optional "skeletonized" raceway with punched out raceway bottom saves material


## Getting Started

To use this file you'll need a copy of OpenSCAD(it's free!): https://www.openscad.org

## Usage

Load the file in OpenSCAD, edit the variables to match your needs, export the model as STL,
slice, and print it. 

Some advice on variables:  Plan to print this at 100% infill, understanding 98% of it will be perimiters anyways so you are really just ensuring that the lid to raceway interface is nice and solid.  Use a shell thickness that is a multiple of your nozzle.  1.2mm shell makes for a good minimum starting point.  Read the associated comments with each variable, as they will help to understand what they do and how to best use them

Always print a short section of raceway to test your variables, BEFORE committing to a large batch of raceways for your project.  Do this for each new type of raceway you generate, whenever you change height(longer fingers are way more flexible), change shell thickness, and even if you add the material saving feature to your render.  Be very sure you are happy with the lid fit before moving forward.  Especially if the raceway will be facing down, you want a firm fit between raceway and lid, so the lids don't rattle annoyingly or try to come loose).


## Built With

[OpenSCAD](https://www.openscad.org/)

## License

This project is licensed under the GNU General Public License v3 (or any later) - see the [LICENSE.md](LICENSE.md) file for details

