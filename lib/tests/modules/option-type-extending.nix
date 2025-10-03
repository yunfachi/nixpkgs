{ lib, ... }:
{
  options =
    let
      # simple option type with no arguments
      simpleType = lib.mkOptionType {
        name = "simple";
      };

      # option type that depends on `self`
      descriptionBasedType = lib.mkOptionType (self: {
        name = self.description;
        description = "description-based";
      });

      # option type that accepts additional arguments
      parametricType =
        (lib.mkOptionType (
          self: namePart: suffix: {
            name = self.description + suffix;
            description = namePart;
          }
        ))
          "parametric"
          "-name-suffix";

      # `__constructor__` testing for different types
      simpleConstructor = simpleType.__constructor__;
      descriptionBasedConstructor = descriptionBasedType.__constructor__;
      parametricConstructor = parametricType.__constructor__ "parametricConstructor" "-too-name-suffix";

      # extend testing on `__constructor__`'ed parametric type
      extendedParametricType = (parametricType.__constructor__ "extendedParametric" "fake").extend (
        final: prev: {
          name = prev.description;
          description = prev.description + "-description-suffix";
        }
      );

      # Testing `__constructor__` after extend
      extendedParametricConstructor = extendedParametricType.__constructor__ "extendedParametricConstructor" "fake";

      # extend on simple and description-based types
      extendedSimpleType = simpleType.extend (
        final: prev: {
          name = "extendedSimple (extended ${prev.name})";
        }
      );

      extendedDescriptionType = descriptionBasedType.extend (
        final: prev: {
          description = prev.description + "-extendedDescription";
        }
      );

    in
    {
      simpleOption = lib.mkOption { type = simpleType; };
      descriptionBasedOption = lib.mkOption { type = descriptionBasedType; };
      parametricOption = lib.mkOption { type = parametricType; };
      parametricConstructorOption = lib.mkOption { type = parametricConstructor; };
      extendedParametricOption = lib.mkOption { type = extendedParametricType; };
      extendedParametricConstructorOption = lib.mkOption { type = extendedParametricConstructor; };
      simpleConstructorOption = lib.mkOption { type = simpleConstructor; };
      descriptionBasedConstructorOption = lib.mkOption { type = descriptionBasedConstructor; };
      extendedSimpleOption = lib.mkOption { type = extendedSimpleType; };
      extendedDescriptionOption = lib.mkOption { type = extendedDescriptionType; };
    };
}
