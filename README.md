MIA_CTScanReconstruction
========================

Medical Image Analysis 2013 - Sinogram Reconstruction and Denoising

The task consists of two parts. Starting point is the output from a CT scan in the form of
sinograms. The general task is to transform these sinograms into a human readable form and
enhance them to make segmentation possible later on.

Part 1: Reconstruction

Each column in the sinogram depicts the data from one scan. The number of lines presents the
different degrees used for the scans. The sinograms used here were sampled at 0 to 179
degrees using 367 sensor elements for each scan.
Reconstruction now follows the principle of turning this sensor lines according to the degree they
were sampled with and sum all results up in one image. Filtering with a ramp­filter in the
frequency domain should be applied to get a clearer result image.

Part 2: Denoising

The output from the reconstruction step are noisy (likely due to hardware and resolution limits).
In this step the image should get smoothed out for further processing with ROF­Denoising for
edge preservation.
