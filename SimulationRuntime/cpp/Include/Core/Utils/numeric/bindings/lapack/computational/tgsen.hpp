//
// Copyright (c) 2002--2010
// Toon Knapen, Karl Meerbergen, Kresimir Fresl,
// Thomas Klimpel and Rutger ter Borg
//
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file LICENSE_1_0.txt or copy at
// http://www.boost.org/LICENSE_1_0.txt)
//
// THIS FILE IS AUTOMATICALLY GENERATED
// PLEASE DO NOT EDIT!
//

#ifndef BOOST_NUMERIC_BINDINGS_LAPACK_COMPUTATIONAL_TGSEN_HPP
#define BOOST_NUMERIC_BINDINGS_LAPACK_COMPUTATIONAL_TGSEN_HPP

#include <boost/assert.hpp>
#include <Core/Utils/numeric/bindings/begin.hpp>
#include <Core/Utils/numeric/bindings/detail/array.hpp>
#include <Core/Utils/numeric/bindings/is_column_major.hpp>
#include <Core/Utils/numeric/bindings/is_complex.hpp>
#include <Core/Utils/numeric/bindings/is_mutable.hpp>
#include <Core/Utils/numeric/bindings/is_real.hpp>
#include <Core/Utils/numeric/bindings/lapack/workspace.hpp>
#include <Core/Utils/numeric/bindings/remove_imaginary.hpp>
#include <Core/Utils/numeric/bindings/size.hpp>
#include <Core/Utils/numeric/bindings/stride.hpp>
#include <Core/Utils/numeric/bindings/traits/detail/utils.hpp>
#include <Core/Utils/numeric/bindings/value_type.hpp>
#include <boost/static_assert.hpp>
#include <boost/type_traits/is_same.hpp>
#include <boost/type_traits/remove_const.hpp>
#include <boost/utility/enable_if.hpp>

//
// The LAPACK-backend for tgsen is the netlib-compatible backend.
//
#include <Core/Utils/numeric/bindings/lapack/detail/lapack.h>
#include <Core/Utils/numeric/bindings/lapack/detail/lapack_option.hpp>

namespace boost {
namespace numeric {
namespace bindings {
namespace lapack {

//
// The detail namespace contains value-type-overloaded functions that
// dispatch to the appropriate back-end LAPACK-routine.
//
namespace detail {

//
// Overloaded function for dispatching to
// * netlib-compatible LAPACK backend (the default), and
// * float value-type.
//
inline std::ptrdiff_t tgsen( const fortran_int_t ijob,
        const fortran_bool_t wantq, const fortran_bool_t wantz,
        const fortran_bool_t* select, const fortran_int_t n, float* a,
        const fortran_int_t lda, float* b, const fortran_int_t ldb,
        float* alphar, float* alphai, float* beta, float* q,
        const fortran_int_t ldq, float* z, const fortran_int_t ldz,
        fortran_int_t& m, float& pl, float& pr, float* dif, float* work,
        const fortran_int_t lwork, fortran_int_t* iwork,
        const fortran_int_t liwork ) {
    fortran_int_t info(0);
    LAPACK_STGSEN( &ijob, &wantq, &wantz, select, &n, a, &lda, b, &ldb,
            alphar, alphai, beta, q, &ldq, z, &ldz, &m, &pl, &pr, dif, work,
            &lwork, iwork, &liwork, &info );
    return info;
}

//
// Overloaded function for dispatching to
// * netlib-compatible LAPACK backend (the default), and
// * double value-type.
//
inline std::ptrdiff_t tgsen( const fortran_int_t ijob,
        const fortran_bool_t wantq, const fortran_bool_t wantz,
        const fortran_bool_t* select, const fortran_int_t n, double* a,
        const fortran_int_t lda, double* b, const fortran_int_t ldb,
        double* alphar, double* alphai, double* beta, double* q,
        const fortran_int_t ldq, double* z, const fortran_int_t ldz,
        fortran_int_t& m, double& pl, double& pr, double* dif, double* work,
        const fortran_int_t lwork, fortran_int_t* iwork,
        const fortran_int_t liwork ) {
    fortran_int_t info(0);
    LAPACK_DTGSEN( &ijob, &wantq, &wantz, select, &n, a, &lda, b, &ldb,
            alphar, alphai, beta, q, &ldq, z, &ldz, &m, &pl, &pr, dif, work,
            &lwork, iwork, &liwork, &info );
    return info;
}

//
// Overloaded function for dispatching to
// * netlib-compatible LAPACK backend (the default), and
// * complex<float> value-type.
//
inline std::ptrdiff_t tgsen( const fortran_int_t ijob,
        const fortran_bool_t wantq, const fortran_bool_t wantz,
        const fortran_bool_t* select, const fortran_int_t n,
        std::complex<float>* a, const fortran_int_t lda,
        std::complex<float>* b, const fortran_int_t ldb,
        std::complex<float>* alpha, std::complex<float>* beta,
        std::complex<float>* q, const fortran_int_t ldq,
        std::complex<float>* z, const fortran_int_t ldz, fortran_int_t& m,
        float& pl, float& pr, float* dif, std::complex<float>* work,
        const fortran_int_t lwork, fortran_int_t* iwork,
        const fortran_int_t liwork ) {
    fortran_int_t info(0);
    LAPACK_CTGSEN( &ijob, &wantq, &wantz, select, &n, a, &lda, b, &ldb, alpha,
            beta, q, &ldq, z, &ldz, &m, &pl, &pr, dif, work, &lwork, iwork,
            &liwork, &info );
    return info;
}

//
// Overloaded function for dispatching to
// * netlib-compatible LAPACK backend (the default), and
// * complex<double> value-type.
//
inline std::ptrdiff_t tgsen( const fortran_int_t ijob,
        const fortran_bool_t wantq, const fortran_bool_t wantz,
        const fortran_bool_t* select, const fortran_int_t n,
        std::complex<double>* a, const fortran_int_t lda,
        std::complex<double>* b, const fortran_int_t ldb,
        std::complex<double>* alpha, std::complex<double>* beta,
        std::complex<double>* q, const fortran_int_t ldq,
        std::complex<double>* z, const fortran_int_t ldz, fortran_int_t& m,
        double& pl, double& pr, double* dif, std::complex<double>* work,
        const fortran_int_t lwork, fortran_int_t* iwork,
        const fortran_int_t liwork ) {
    fortran_int_t info(0);
    LAPACK_ZTGSEN( &ijob, &wantq, &wantz, select, &n, a, &lda, b, &ldb, alpha,
            beta, q, &ldq, z, &ldz, &m, &pl, &pr, dif, work, &lwork, iwork,
            &liwork, &info );
    return info;
}

} // namespace detail

//
// Value-type based template class. Use this class if you need a type
// for dispatching to tgsen.
//
template< typename Value, typename Enable = void >
struct tgsen_impl {};

//
// This implementation is enabled if Value is a real type.
//
template< typename Value >
struct tgsen_impl< Value, typename boost::enable_if< is_real< Value > >::type > {

    typedef Value value_type;
    typedef typename remove_imaginary< Value >::type real_type;

    //
    // Static member function for user-defined workspaces, that
    // * Deduces the required arguments for dispatching to LAPACK, and
    // * Asserts that most arguments make sense.
    //
    template< typename VectorSELECT, typename MatrixA, typename MatrixB,
            typename VectorALPHAR, typename VectorALPHAI, typename VectorBETA,
            typename MatrixQ, typename MatrixZ, typename VectorDIF,
            typename WORK, typename IWORK >
    static std::ptrdiff_t invoke( const fortran_int_t ijob,
            const fortran_bool_t wantq, const fortran_bool_t wantz,
            const VectorSELECT& select, MatrixA& a, MatrixB& b,
            VectorALPHAR& alphar, VectorALPHAI& alphai, VectorBETA& beta,
            MatrixQ& q, MatrixZ& z, fortran_int_t& m, real_type& pl,
            real_type& pr, VectorDIF& dif, detail::workspace2< WORK,
            IWORK > work ) {
        namespace bindings = ::boost::numeric::bindings;
        BOOST_STATIC_ASSERT( (bindings::is_column_major< MatrixA >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_column_major< MatrixB >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_column_major< MatrixQ >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_column_major< MatrixZ >::value) );
        BOOST_STATIC_ASSERT( (boost::is_same< typename remove_const<
                typename bindings::value_type< MatrixA >::type >::type,
                typename remove_const< typename bindings::value_type<
                MatrixB >::type >::type >::value) );
        BOOST_STATIC_ASSERT( (boost::is_same< typename remove_const<
                typename bindings::value_type< MatrixA >::type >::type,
                typename remove_const< typename bindings::value_type<
                VectorALPHAR >::type >::type >::value) );
        BOOST_STATIC_ASSERT( (boost::is_same< typename remove_const<
                typename bindings::value_type< MatrixA >::type >::type,
                typename remove_const< typename bindings::value_type<
                VectorALPHAI >::type >::type >::value) );
        BOOST_STATIC_ASSERT( (boost::is_same< typename remove_const<
                typename bindings::value_type< MatrixA >::type >::type,
                typename remove_const< typename bindings::value_type<
                VectorBETA >::type >::type >::value) );
        BOOST_STATIC_ASSERT( (boost::is_same< typename remove_const<
                typename bindings::value_type< MatrixA >::type >::type,
                typename remove_const< typename bindings::value_type<
                MatrixQ >::type >::type >::value) );
        BOOST_STATIC_ASSERT( (boost::is_same< typename remove_const<
                typename bindings::value_type< MatrixA >::type >::type,
                typename remove_const< typename bindings::value_type<
                MatrixZ >::type >::type >::value) );
        BOOST_STATIC_ASSERT( (boost::is_same< typename remove_const<
                typename bindings::value_type< MatrixA >::type >::type,
                typename remove_const< typename bindings::value_type<
                VectorDIF >::type >::type >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_mutable< MatrixA >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_mutable< MatrixB >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_mutable< VectorALPHAR >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_mutable< VectorALPHAI >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_mutable< VectorBETA >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_mutable< MatrixQ >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_mutable< MatrixZ >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_mutable< VectorDIF >::value) );
        BOOST_ASSERT( bindings::size(alphai) >= bindings::size_column(a) );
        BOOST_ASSERT( bindings::size(alphar) >= bindings::size_column(a) );
        BOOST_ASSERT( bindings::size(select) >= bindings::size_column(a) );
        BOOST_ASSERT( bindings::size(work.select(fortran_int_t())) >=
                min_size_iwork( ijob, bindings::size_column(a), m ));
        BOOST_ASSERT( bindings::size(work.select(real_type())) >=
                min_size_work( ijob, bindings::size_column(a), m ));
        BOOST_ASSERT( bindings::size_column(a) >= 0 );
        BOOST_ASSERT( bindings::size_minor(a) == 1 ||
                bindings::stride_minor(a) == 1 );
        BOOST_ASSERT( bindings::size_minor(b) == 1 ||
                bindings::stride_minor(b) == 1 );
        BOOST_ASSERT( bindings::size_minor(q) == 1 ||
                bindings::stride_minor(q) == 1 );
        BOOST_ASSERT( bindings::size_minor(z) == 1 ||
                bindings::stride_minor(z) == 1 );
        BOOST_ASSERT( bindings::stride_major(a) >= std::max< std::ptrdiff_t >(1,
                bindings::size_column(a)) );
        BOOST_ASSERT( bindings::stride_major(b) >= std::max< std::ptrdiff_t >(1,
                bindings::size_column(a)) );
        return detail::tgsen( ijob, wantq, wantz,
                bindings::begin_value(select), bindings::size_column(a),
                bindings::begin_value(a), bindings::stride_major(a),
                bindings::begin_value(b), bindings::stride_major(b),
                bindings::begin_value(alphar), bindings::begin_value(alphai),
                bindings::begin_value(beta), bindings::begin_value(q),
                bindings::stride_major(q), bindings::begin_value(z),
                bindings::stride_major(z), m, pl, pr,
                bindings::begin_value(dif),
                bindings::begin_value(work.select(real_type())),
                bindings::size(work.select(real_type())),
                bindings::begin_value(work.select(fortran_int_t())),
                bindings::size(work.select(fortran_int_t())) );
    }

    //
    // Static member function that
    // * Figures out the minimal workspace requirements, and passes
    //   the results to the user-defined workspace overload of the
    //   invoke static member function
    // * Enables the unblocked algorithm (BLAS level 2)
    //
    template< typename VectorSELECT, typename MatrixA, typename MatrixB,
            typename VectorALPHAR, typename VectorALPHAI, typename VectorBETA,
            typename MatrixQ, typename MatrixZ, typename VectorDIF >
    static std::ptrdiff_t invoke( const fortran_int_t ijob,
            const fortran_bool_t wantq, const fortran_bool_t wantz,
            const VectorSELECT& select, MatrixA& a, MatrixB& b,
            VectorALPHAR& alphar, VectorALPHAI& alphai, VectorBETA& beta,
            MatrixQ& q, MatrixZ& z, fortran_int_t& m, real_type& pl,
            real_type& pr, VectorDIF& dif, minimal_workspace ) {
        namespace bindings = ::boost::numeric::bindings;
        bindings::detail::array< real_type > tmp_work( min_size_work( ijob,
                bindings::size_column(a), m ) );
        bindings::detail::array< fortran_int_t > tmp_iwork(
                min_size_iwork( ijob, bindings::size_column(a), m ) );
        return invoke( ijob, wantq, wantz, select, a, b, alphar, alphai, beta,
                q, z, m, pl, pr, dif, workspace( tmp_work, tmp_iwork ) );
    }

    //
    // Static member function that
    // * Figures out the optimal workspace requirements, and passes
    //   the results to the user-defined workspace overload of the
    //   invoke static member
    // * Enables the blocked algorithm (BLAS level 3)
    //
    template< typename VectorSELECT, typename MatrixA, typename MatrixB,
            typename VectorALPHAR, typename VectorALPHAI, typename VectorBETA,
            typename MatrixQ, typename MatrixZ, typename VectorDIF >
    static std::ptrdiff_t invoke( const fortran_int_t ijob,
            const fortran_bool_t wantq, const fortran_bool_t wantz,
            const VectorSELECT& select, MatrixA& a, MatrixB& b,
            VectorALPHAR& alphar, VectorALPHAI& alphai, VectorBETA& beta,
            MatrixQ& q, MatrixZ& z, fortran_int_t& m, real_type& pl,
            real_type& pr, VectorDIF& dif, optimal_workspace ) {
        namespace bindings = ::boost::numeric::bindings;
        real_type opt_size_work;
        fortran_int_t opt_size_iwork;
        detail::tgsen( ijob, wantq, wantz, bindings::begin_value(select),
                bindings::size_column(a), bindings::begin_value(a),
                bindings::stride_major(a), bindings::begin_value(b),
                bindings::stride_major(b), bindings::begin_value(alphar),
                bindings::begin_value(alphai), bindings::begin_value(beta),
                bindings::begin_value(q), bindings::stride_major(q),
                bindings::begin_value(z), bindings::stride_major(z), m, pl,
                pr, bindings::begin_value(dif), &opt_size_work, -1,
                &opt_size_iwork, -1 );
        bindings::detail::array< real_type > tmp_work(
                traits::detail::to_int( opt_size_work ) );
        bindings::detail::array< fortran_int_t > tmp_iwork(
                opt_size_iwork );
        return invoke( ijob, wantq, wantz, select, a, b, alphar, alphai, beta,
                q, z, m, pl, pr, dif, workspace( tmp_work, tmp_iwork ) );
    }

    //
    // Static member function that returns the minimum size of
    // workspace-array work.
    //
    static std::ptrdiff_t min_size_work( const std::ptrdiff_t ijob,
            const std::ptrdiff_t n, fortran_int_t& m ) {
        if ( ijob == 1 || ijob == 2 || ijob == 4 )
            return std::max< std::ptrdiff_t >(4*n+16, 2*m*(n-m));
        else if ( ijob == 3 || ijob == 5 )
            return std::max< std::ptrdiff_t >(4*n+16, 4*m*(n-m));
        else // ijob == 0
            return std::max< std::ptrdiff_t >(1, 4*n+16);
    }

    //
    // Static member function that returns the minimum size of
    // workspace-array iwork.
    //
    static std::ptrdiff_t min_size_iwork( const std::ptrdiff_t ijob,
            const std::ptrdiff_t n, fortran_int_t& m ) {
        if ( ijob == 1 || ijob == 2 || ijob == 4 )
            return std::max< std::ptrdiff_t >(1, n+6);
        else if ( ijob == 3 || ijob == 5 )
            return std::max< std::ptrdiff_t >(2*m*(n-m), n+6);
        else // ijob == 0
            return 1;
    }
};

//
// This implementation is enabled if Value is a complex type.
//
template< typename Value >
struct tgsen_impl< Value, typename boost::enable_if< is_complex< Value > >::type > {

    typedef Value value_type;
    typedef typename remove_imaginary< Value >::type real_type;

    //
    // Static member function for user-defined workspaces, that
    // * Deduces the required arguments for dispatching to LAPACK, and
    // * Asserts that most arguments make sense.
    //
    template< typename VectorSELECT, typename MatrixA, typename MatrixB,
            typename VectorALPHA, typename VectorBETA, typename MatrixQ,
            typename MatrixZ, typename VectorDIF, typename WORK,
            typename IWORK >
    static std::ptrdiff_t invoke( const fortran_int_t ijob,
            const fortran_bool_t wantq, const fortran_bool_t wantz,
            const VectorSELECT& select, MatrixA& a, MatrixB& b,
            VectorALPHA& alpha, VectorBETA& beta, MatrixQ& q, MatrixZ& z,
            fortran_int_t& m, real_type& pl, real_type& pr,
            VectorDIF& dif, detail::workspace2< WORK, IWORK > work ) {
        namespace bindings = ::boost::numeric::bindings;
        BOOST_STATIC_ASSERT( (bindings::is_column_major< MatrixA >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_column_major< MatrixB >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_column_major< MatrixQ >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_column_major< MatrixZ >::value) );
        BOOST_STATIC_ASSERT( (boost::is_same< typename remove_const<
                typename bindings::value_type< MatrixA >::type >::type,
                typename remove_const< typename bindings::value_type<
                MatrixB >::type >::type >::value) );
        BOOST_STATIC_ASSERT( (boost::is_same< typename remove_const<
                typename bindings::value_type< MatrixA >::type >::type,
                typename remove_const< typename bindings::value_type<
                VectorALPHA >::type >::type >::value) );
        BOOST_STATIC_ASSERT( (boost::is_same< typename remove_const<
                typename bindings::value_type< MatrixA >::type >::type,
                typename remove_const< typename bindings::value_type<
                VectorBETA >::type >::type >::value) );
        BOOST_STATIC_ASSERT( (boost::is_same< typename remove_const<
                typename bindings::value_type< MatrixA >::type >::type,
                typename remove_const< typename bindings::value_type<
                MatrixQ >::type >::type >::value) );
        BOOST_STATIC_ASSERT( (boost::is_same< typename remove_const<
                typename bindings::value_type< MatrixA >::type >::type,
                typename remove_const< typename bindings::value_type<
                MatrixZ >::type >::type >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_mutable< MatrixA >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_mutable< MatrixB >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_mutable< VectorALPHA >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_mutable< VectorBETA >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_mutable< MatrixQ >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_mutable< MatrixZ >::value) );
        BOOST_STATIC_ASSERT( (bindings::is_mutable< VectorDIF >::value) );
        BOOST_ASSERT( bindings::size(alpha) >= bindings::size_column(a) );
        BOOST_ASSERT( bindings::size(select) >= bindings::size_column(a) );
        BOOST_ASSERT( bindings::size(work.select(fortran_int_t())) >=
                min_size_iwork( ijob, bindings::size_column(a), m ));
        BOOST_ASSERT( bindings::size(work.select(value_type())) >=
                min_size_work( ijob, bindings::size_column(a), m ));
        BOOST_ASSERT( bindings::size_column(a) >= 0 );
        BOOST_ASSERT( bindings::size_minor(a) == 1 ||
                bindings::stride_minor(a) == 1 );
        BOOST_ASSERT( bindings::size_minor(b) == 1 ||
                bindings::stride_minor(b) == 1 );
        BOOST_ASSERT( bindings::size_minor(q) == 1 ||
                bindings::stride_minor(q) == 1 );
        BOOST_ASSERT( bindings::size_minor(z) == 1 ||
                bindings::stride_minor(z) == 1 );
        BOOST_ASSERT( bindings::stride_major(a) >= std::max< std::ptrdiff_t >(1,
                bindings::size_column(a)) );
        BOOST_ASSERT( bindings::stride_major(b) >= std::max< std::ptrdiff_t >(1,
                bindings::size_column(a)) );
        return detail::tgsen( ijob, wantq, wantz,
                bindings::begin_value(select), bindings::size_column(a),
                bindings::begin_value(a), bindings::stride_major(a),
                bindings::begin_value(b), bindings::stride_major(b),
                bindings::begin_value(alpha), bindings::begin_value(beta),
                bindings::begin_value(q), bindings::stride_major(q),
                bindings::begin_value(z), bindings::stride_major(z), m, pl,
                pr, bindings::begin_value(dif),
                bindings::begin_value(work.select(value_type())),
                bindings::size(work.select(value_type())),
                bindings::begin_value(work.select(fortran_int_t())),
                bindings::size(work.select(fortran_int_t())) );
    }

    //
    // Static member function that
    // * Figures out the minimal workspace requirements, and passes
    //   the results to the user-defined workspace overload of the
    //   invoke static member function
    // * Enables the unblocked algorithm (BLAS level 2)
    //
    template< typename VectorSELECT, typename MatrixA, typename MatrixB,
            typename VectorALPHA, typename VectorBETA, typename MatrixQ,
            typename MatrixZ, typename VectorDIF >
    static std::ptrdiff_t invoke( const fortran_int_t ijob,
            const fortran_bool_t wantq, const fortran_bool_t wantz,
            const VectorSELECT& select, MatrixA& a, MatrixB& b,
            VectorALPHA& alpha, VectorBETA& beta, MatrixQ& q, MatrixZ& z,
            fortran_int_t& m, real_type& pl, real_type& pr,
            VectorDIF& dif, minimal_workspace ) {
        namespace bindings = ::boost::numeric::bindings;
        bindings::detail::array< value_type > tmp_work( min_size_work( ijob,
                bindings::size_column(a), m ) );
        bindings::detail::array< fortran_int_t > tmp_iwork(
                min_size_iwork( ijob, bindings::size_column(a), m ) );
        return invoke( ijob, wantq, wantz, select, a, b, alpha, beta, q, z, m,
                pl, pr, dif, workspace( tmp_work, tmp_iwork ) );
    }

    //
    // Static member function that
    // * Figures out the optimal workspace requirements, and passes
    //   the results to the user-defined workspace overload of the
    //   invoke static member
    // * Enables the blocked algorithm (BLAS level 3)
    //
    template< typename VectorSELECT, typename MatrixA, typename MatrixB,
            typename VectorALPHA, typename VectorBETA, typename MatrixQ,
            typename MatrixZ, typename VectorDIF >
    static std::ptrdiff_t invoke( const fortran_int_t ijob,
            const fortran_bool_t wantq, const fortran_bool_t wantz,
            const VectorSELECT& select, MatrixA& a, MatrixB& b,
            VectorALPHA& alpha, VectorBETA& beta, MatrixQ& q, MatrixZ& z,
            fortran_int_t& m, real_type& pl, real_type& pr,
            VectorDIF& dif, optimal_workspace ) {
        namespace bindings = ::boost::numeric::bindings;
        value_type opt_size_work;
        fortran_int_t opt_size_iwork;
        detail::tgsen( ijob, wantq, wantz, bindings::begin_value(select),
                bindings::size_column(a), bindings::begin_value(a),
                bindings::stride_major(a), bindings::begin_value(b),
                bindings::stride_major(b), bindings::begin_value(alpha),
                bindings::begin_value(beta), bindings::begin_value(q),
                bindings::stride_major(q), bindings::begin_value(z),
                bindings::stride_major(z), m, pl, pr,
                bindings::begin_value(dif), &opt_size_work, -1,
                &opt_size_iwork, -1 );
        bindings::detail::array< value_type > tmp_work(
                traits::detail::to_int( opt_size_work ) );
        bindings::detail::array< fortran_int_t > tmp_iwork(
                opt_size_iwork );
        return invoke( ijob, wantq, wantz, select, a, b, alpha, beta, q, z, m,
                pl, pr, dif, workspace( tmp_work, tmp_iwork ) );
    }

    //
    // Static member function that returns the minimum size of
    // workspace-array work.
    //
    static std::ptrdiff_t min_size_work( const std::ptrdiff_t ijob,
            const std::ptrdiff_t n, fortran_int_t& m ) {
        if ( ijob == 1 || ijob == 2 || ijob == 4 )
            return std::max< std::ptrdiff_t >(1, 2*m*(n-m));
        else if ( ijob == 3 || ijob == 5 )
            return std::max< std::ptrdiff_t >(1, 4*m*(n-m));
        else // ijob == 0
            return 1;
    }

    //
    // Static member function that returns the minimum size of
    // workspace-array iwork.
    //
    static std::ptrdiff_t min_size_iwork( const std::ptrdiff_t ijob,
            const std::ptrdiff_t n, fortran_int_t& m ) {
        if ( ijob == 1 || ijob == 2 || ijob == 4 )
            return std::max< std::ptrdiff_t >(1, n+2);
        else if ( ijob == 3 || ijob == 5 )
            return std::max< std::ptrdiff_t >(2*m*(n-m), n+2);
        else // ijob == 0
            return 1;
    }
};


//
// Functions for direct use. These functions are overloaded for temporaries,
// so that wrapped types can still be passed and used for write-access. In
// addition, if applicable, they are overloaded for user-defined workspaces.
// Calls to these functions are passed to the tgsen_impl classes. In the
// documentation, most overloads are collapsed to avoid a large number of
// prototypes which are very similar.
//

//
// Overloaded function for tgsen. Its overload differs for
// * User-defined workspace
//
template< typename VectorSELECT, typename MatrixA, typename MatrixB,
        typename VectorALPHAR, typename VectorALPHAI, typename VectorBETA,
        typename MatrixQ, typename MatrixZ, typename VectorDIF,
        typename Workspace >
inline typename boost::enable_if< detail::is_workspace< Workspace >,
        std::ptrdiff_t >::type
tgsen( const fortran_int_t ijob, const fortran_bool_t wantq,
        const fortran_bool_t wantz, const VectorSELECT& select, MatrixA& a,
        MatrixB& b, VectorALPHAR& alphar, VectorALPHAI& alphai,
        VectorBETA& beta, MatrixQ& q, MatrixZ& z, fortran_int_t& m,
        typename remove_imaginary< typename bindings::value_type<
        MatrixA >::type >::type& pl, typename remove_imaginary<
        typename bindings::value_type< MatrixA >::type >::type& pr,
        VectorDIF& dif, Workspace work ) {
    return tgsen_impl< typename bindings::value_type<
            MatrixA >::type >::invoke( ijob, wantq, wantz, select, a, b,
            alphar, alphai, beta, q, z, m, pl, pr, dif, work );
}

//
// Overloaded function for tgsen. Its overload differs for
// * Default workspace-type (optimal)
//
template< typename VectorSELECT, typename MatrixA, typename MatrixB,
        typename VectorALPHAR, typename VectorALPHAI, typename VectorBETA,
        typename MatrixQ, typename MatrixZ, typename VectorDIF >
inline typename boost::disable_if< detail::is_workspace< VectorDIF >,
        std::ptrdiff_t >::type
tgsen( const fortran_int_t ijob, const fortran_bool_t wantq,
        const fortran_bool_t wantz, const VectorSELECT& select, MatrixA& a,
        MatrixB& b, VectorALPHAR& alphar, VectorALPHAI& alphai,
        VectorBETA& beta, MatrixQ& q, MatrixZ& z, fortran_int_t& m,
        typename remove_imaginary< typename bindings::value_type<
        MatrixA >::type >::type& pl, typename remove_imaginary<
        typename bindings::value_type< MatrixA >::type >::type& pr,
        VectorDIF& dif ) {
    return tgsen_impl< typename bindings::value_type<
            MatrixA >::type >::invoke( ijob, wantq, wantz, select, a, b,
            alphar, alphai, beta, q, z, m, pl, pr, dif, optimal_workspace() );
}

//
// Overloaded function for tgsen. Its overload differs for
// * User-defined workspace
//
template< typename VectorSELECT, typename MatrixA, typename MatrixB,
        typename VectorALPHA, typename VectorBETA, typename MatrixQ,
        typename MatrixZ, typename VectorDIF, typename Workspace >
inline typename boost::enable_if< detail::is_workspace< Workspace >,
        std::ptrdiff_t >::type
tgsen( const fortran_int_t ijob, const fortran_bool_t wantq,
        const fortran_bool_t wantz, const VectorSELECT& select, MatrixA& a,
        MatrixB& b, VectorALPHA& alpha, VectorBETA& beta, MatrixQ& q,
        MatrixZ& z, fortran_int_t& m, typename remove_imaginary<
        typename bindings::value_type< MatrixA >::type >::type& pl,
        typename remove_imaginary< typename bindings::value_type<
        MatrixA >::type >::type& pr, VectorDIF& dif, Workspace work ) {
    return tgsen_impl< typename bindings::value_type<
            MatrixA >::type >::invoke( ijob, wantq, wantz, select, a, b,
            alpha, beta, q, z, m, pl, pr, dif, work );
}

//
// Overloaded function for tgsen. Its overload differs for
// * Default workspace-type (optimal)
//
template< typename VectorSELECT, typename MatrixA, typename MatrixB,
        typename VectorALPHA, typename VectorBETA, typename MatrixQ,
        typename MatrixZ, typename VectorDIF >
inline typename boost::disable_if< detail::is_workspace< VectorDIF >,
        std::ptrdiff_t >::type
tgsen( const fortran_int_t ijob, const fortran_bool_t wantq,
        const fortran_bool_t wantz, const VectorSELECT& select, MatrixA& a,
        MatrixB& b, VectorALPHA& alpha, VectorBETA& beta, MatrixQ& q,
        MatrixZ& z, fortran_int_t& m, typename remove_imaginary<
        typename bindings::value_type< MatrixA >::type >::type& pl,
        typename remove_imaginary< typename bindings::value_type<
        MatrixA >::type >::type& pr, VectorDIF& dif ) {
    return tgsen_impl< typename bindings::value_type<
            MatrixA >::type >::invoke( ijob, wantq, wantz, select, a, b,
            alpha, beta, q, z, m, pl, pr, dif, optimal_workspace() );
}

} // namespace lapack
} // namespace bindings
} // namespace numeric
} // namespace boost

#endif
