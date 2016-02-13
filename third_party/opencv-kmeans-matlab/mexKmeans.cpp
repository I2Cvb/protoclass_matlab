//
// Performs k-means on input data.
// Interfacing with OpenCV implementation.
//
// Vladislavs D.
//

#include "mex.h"
#include "matrix.h"
#include <opencv2/opencv.hpp>

// input variables
#define DATA 0		// samples
#define K 1		// number of clusters
#define EPSL 2		// stopping criteria: epsilon (e.g. 0.0001)
#define NITR 3		// stopping criteria: number of iterations (e.g. 10K)
#define NATT 4		// number of attempts

// output variables
#define CENT 0

using namespace std;
using namespace cv;

// entry point
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
	
	// using kmeans++ for center initialization
	int flags = cv::KMEANS_PP_CENTERS;

	//
	// Check input arguments
	//

	if (  nrhs < 5 )
		mexErrMsgTxt( "Five input arguments required." );

	// data must be of double type
	if ( !(mxGetClassID(prhs[DATA]) == mxSINGLE_CLASS) )
		mexErrMsgTxt( "Input data must be single type." );

	//
	// Get input data
	//

	// get number of clusters argument
	double *tmp = mxGetPr( prhs[K] );
	int k = static_cast<int>( *tmp );

	if ( k <= 0 )
		mexErrMsgTxt( "Number of desired clusters must be a positive integer." );

	// get number of rows and columns of the input
	long nDims = static_cast<long>( mxGetM(prhs[DATA]) );
	long nSamples = static_cast<long>( mxGetN(prhs[DATA]) );

	// get pointer to input data
	float *data = (float*) mxGetData( prhs[DATA] );

	// create a OpenCV matrix with supplied data 
	Mat cvData = Mat( nDims, nSamples, DataType<float>::type, data );

	// transpose - samples must lay in rows
	cvData = cvData.t();

	//
	// Get parameters
	//

	// stopping criteria - epsilon
	tmp = mxGetPr( prhs[EPSL] );
	double epsilon = static_cast<double>( *tmp );

	// stopping criteria - number of iterations
	tmp = mxGetPr( prhs[NITR] );
	long nIter = static_cast<double>( *tmp );

	// number of attempts
	tmp = mxGetPr( prhs[NATT] );
	long nAttempts = static_cast<long>( *tmp );

	//
	// Launch the k-means algorithm
	//

	// build criteria object
	TermCriteria tCrit = TermCriteria( CV_TERMCRIT_ITER|CV_TERMCRIT_EPS, epsilon, nIter );

	// output
	Mat cvLabels;
	Mat cvCenters;
	
	// call the kmeans function
	kmeans( cvData, k, cvLabels, tCrit, nAttempts, flags, cvCenters );

	// transpose centers matrix - back to MATLAB's convention
	cvCenters = cvCenters.t();

	//
	// Copy the centers into Matlab's structures
	//

	// allocate centers matrix (MATLAB)
	mxArray *centers = mxCreateDoubleMatrix( nDims, k, mxREAL );

	// get C pointer to the data
	double *c = mxGetPr( centers );

	// copy from Mat -> C pointer
	long cnt = 0;
	for ( long i = 0 ; i < cvCenters.rows ; i++ ) {
		// get pointer to i-th row
		const float *ci = cvCenters.ptr<float>(i);

		for (long j = 0 ; j < cvCenters.cols ; j++ ) {
			c[cnt] = ci[j];
			cnt++;
		}
	}

	// assign output pointer
	plhs[CENT] = centers;

}

