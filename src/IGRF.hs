-- | An implementation of the International Geomagnetic Reference Field, as defined at <http://www.ngdc.noaa.gov/IAGA/vmod/igrf.html>.
module IGRF
(
  MagneticModel(..)
, igrf11
, fieldAtTime
, evaluateModelGradientInLocalTangentPlane
)
where

import Data.VectorSpace
import Math.SphericalHarmonics

-- | Represents a spherical harmonic model of a magnetic field.
data MagneticModel a = MagneticModel 
                     {
                       fieldAtEpoch :: SphericalHarmonicModel a     -- ^ Field at model epoch in nT, reference radius in km
                     , secularVariation :: SphericalHarmonicModel a -- ^ Secular variation in nT / yr, reference radius in km
                     }

-- | Gets a spherical harmonic model of a magnetic field at a specified time offset from the model epoch.
fieldAtTime :: (Fractional a, Eq a) => MagneticModel a -- ^ Magnetic field model
            -> a -- ^ Time since model epoch (year)
            -> SphericalHarmonicModel a -- ^ Spherical harmonic model of magnetic field at specified time. Field in nT, reference radius in km
fieldAtTime m t = (fieldAtEpoch m) ^+^ (t *^ secularVariation m)

-- | The International Geomagnetic Reference Field model, 11th edition.
-- Model epoch is January 1st, 2010.
igrf11 :: (Fractional a) => MagneticModel a
igrf11 = MagneticModel
       {
         fieldAtEpoch = f
       , secularVariation = s
       }
  where
    f = scaledSphericalHarmonicModel r fcs
    fcs              = [(0, 0),
                        (-29496.5, 0), (-1585.9, 4945.1),
                        (-2396.6, 0), (3026.0, -2707.7), (1668.6, -575.4),
                        (1339.7, 0), (-2326.3, -160.5), (1231.7, 251.7), (634.2, -536.8),
                        (912.6, 0), (809.0, 286.5), (166.6, -211.2), (-357.1, 164.4), (89.7, -309.2),
                        (-231.1, 0), (357.2, 44.7), (200.3, 188.9), (-141.2, -118.1), (-163.1, 0.1), (-7.7, 100.9),
                        (72.8, 0), (68.6, -20.8), (76.0, 44.2), (-141.4, 61.5), (-22.9, -66.3), (13.1, 3.1), (-77.9, 54.9),
                        (80.4, 0), (-75.0, -57.8), (-4.7, -21.2), (45.3, 6.6), (14.0, 24.9), (10.4, 7.0), (1.6, -27.7), (4.9, -3.4),
                        (24.3, 0), (8.2, 10.9), (-14.5, -20.0), (-5.7, 11.9), (-19.3, -17.4), (11.6, 16.7), (10.9, 7.1), (-14.1, -10.8), (-3.7, 1.7),
                        (5.4, 0), (9.4, -20.5), (3.4, 11.6), (-5.3, 12.8), (3.1, -7.2), (-12.4, -7.4), (-0.8, 8.0), (8.4, 2.2), (-8.4, -6.1), (-10.1, 7.0),
                        (-2.0, 0), (-6.3, 2.8), (0.9, -0.1), (-1.1, 4.7), (-0.2, 4.4), (2.5, -7.2), (-0.3, -1.0), (2.2, -4.0), (3.1, -2.0), (-1.0, -2.0), (-2.8, -8.3),
                        (3.0, 0), (-1.5, 0.1), (-2.1, 1.7), (1.6, -0.6), (-0.5, -1.8), (0.5, 0.9), (-0.8, -0.4), (0.4, -2.5), (1.8, -1.3), (0.2, -2.1), (0.8, -1.9), (3.8, -1.8),
                        (-2.1, 0), (-0.2, -0.8), (0.3, 0.3), (1.0, 2.2), (-0.7, -2.5), (0.9, 0.5), (-0.1, 0.6), (0.5, 0.0), (-0.4, 0.1), (-0.4, 0.3), (0.2, -0.9), (-0.8, -0.2), (0.0, 0.8),
                        (-0.2, 0), (-0.9, -0.8), (0.3, 0.3), (0.4, 1.7), (-0.4, -0.6), (1.1, -1.2), (-0.3, -0.1), (0.8, 0.5), (-0.2, 0.1), (0.4, 0.5), (0.0, 0.4), (0.4, -0.2), (-0.3, -0.5), (-0.3, -0.8)
                       ]
    s = scaledSphericalHarmonicModel r scs
    scs              = [(0, 0),
                        (11.4, 0), (16.7, -28.8),
                        (-11.3, 0), (-3.9, -23.0), (2.7, -12.9),
                        (1.3, 0), (-3.9, 8.6), (-2.9, -2.9), (-8.1, -2.1),
                        (-1.4, 0), (2.0, 0.4), (-8.9, 3.2), (4.4, 3.6), (-2.3, -0.8),
                        (-0.5, 0), (0.5, 0.5), (-1.5, 1.5), (-0.7, 0.9), (1.3, 3.7), (1.4, -0.6),
                        (-0.3, 0), (-0.3, -0.1), (-0.3, -2.1), (1.9, -0.4), (-1.6, -0.5), (-0.2, 0.8), (1.8, 0.5),
                        (0.2, 0), (-0.1, 0.6), (-0.6, 0.3), (1.4, -0.2), (0.3, -0.1), (0.1, -0.8), (-0.8, -0.3), (0.4, 0.2),
                        (-0.1, 0), (0.1, 0.0), (-0.5, 0.2), (0.3, 0.5), (-0.3, 0.4), (0.3, 0.1), (0.2, -0.1), (-0.5, 0.4), (0.2, 0.4)
                       ]
    r = 6371.2
