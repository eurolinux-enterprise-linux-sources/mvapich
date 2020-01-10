############################################################################
#
# SRPM for mvapich (MPI-I)
#
#############################################################################

# Define this if you want to leave build root tree
# type: bool (0/1)
%{!?leave_build_root: %define leave_build_root 0}
# Define this if you want to enable _check_files macro
# type: bool (0/1)
%{!?use_check_files: %define use_check_files 1}
# type: string (compiler used for MPI build)
%{!?compiler: %define compiler gcc}
# type: string (device used for mpi build)
%{!?mpi_device: %define mpi_device ch_gen2}
# type: string (path to openib driver)
%{!?openib_prefix: %define openib_prefix /usr}
# type: string (root path to install shell scripts)
%{!?shell_scripts_path: %define shell_scripts_path %{_bindir}}
# type: string (base name of the shell scripts)
%{!?shell_scripts_basename: %define shell_scripts_basename mpivars}
# Define it if you want to enable the mpi-selector functionality?
# type: bool (0/1)
%{!?use_mpi_selector: %define use_mpi_selector 0}
# The name of the mpi-selector RPM.  Can vary from system to system.
# type: string (name of mpi-selector RPM)
%{!?mpi_selector_rpm_name: %define mpi_selector_rpm_name mpi-selector}
# The location of the mpi-selector executable (can be a relative path
# name if "mpi-selector" can be found in the path)
# type: string (path to mpi-selector executable)
%{!?mpi_selector: %define mpi_selector mpi-selector}

#############################################################################

Summary: MPI implementation over Infiniband RDMA-enabled interconnect
Name: %{?_name:%{_name}}%{!?_name:mvapich}
Version: 1.2.0
Release: 3562
License: BSD
Group: Development/Libraries
Source: mvapich-%{version}-%{release}.tar.gz
Packager: %{?_packager:%{_packager}}%{!?_packager:%{_vendor}}
Vendor: %{?_vendorinfo:%{_vendorinfo}}%{!?_vendorinfo:%{_vendor}}
Distribution: %{?_distribution:%{_distribution}}%{!?_distribution:%{_vendor}}
URL: http://nowlab.cse.ohio-state.edu/projects/mpi-iba/index.html
Prefix: %{_prefix}
Requires: libibverbs libibumad
%if %{use_mpi_selector}
Requires: %{mpi_selector_rpm_name}
%endif
BuildRoot: %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

%if %(test "%{compiler}" != "gcc" && echo 1 || echo 0)
AutoReq: no 
%endif

%description
This is high performance and scalable MPI-1 implementation over Infiniband and RDMA-enabled interconnect.
This implementation is based on  MPICH and MVICH. MVAPICH is pronounced as `em-vah-pich''. 

#############################################################################

%if %(test "%{_prefix}" = "/usr" && echo 1 || echo 0)
%global _sysconfdir /etc
%else
%global _sysconfdir %{_prefix}/etc
%endif

%if !%{use_check_files}
%define __check_files %{nil}
%endif

#Disable debug info package
%define debug_package %{nil}

#############################################################################
%prep
%if !%{leave_build_root}
rm -rf $RPM_BUILD_ROOT
%endif

%setup -q -n mvapich-%{version}-%{release}

#############################################################################
%install
#############################################################################
# Build part of rpm 
# (workaround for SUSE issue, _build_ macro removes $RPM_BUILD_ROOT)
# Initialization
ARCH_NAME=
IB_INCLUDE=
IB_LIB=
OPTIMIZATION_FLAG="-O3 -fno-strict-aliasing"
BIT=
CONFIG_ENABLE_F77="--enable-f77"
CONFIG_ENABLE_F90="--enable-f90"
EXTRA_CFLAG=
MPE_FLAGS=
conffile=mvapich.conf
buildidfile=BUILDID
#############################################################################
# Compiler definition
# GNU compilers
%if %(test "%{compiler}" = "gcc" && echo 1 || echo 0)
    export CC=gcc
    export CXX=g++
    gcc_ver=`gcc -dumpversion | awk -F. '{print $1}'`
    # For systems with mixed gcc-fortran install.
    if [ $gcc_ver -gt 3 ]; then
        # new gcc version
        export FC=gfortran
        export F77=gfortran
        export F90=gfortran
        export F77_GETARGDECL=" "
    else
        # old gcc version
        export FC=g77
        export F77=g77
        export F90=g77
        CONFIG_ENABLE_F90="--disable-f90"
    fi
    export CFLAGS="-Wall"
    export FFLAGS="-fPIC"
    export CXXFLAGS="-fPIC"
    export F90FLAGS=""
    export CONFIG_FLAGS=""
%endif
# Intel compiler
%if %(test "%{compiler}" = "intel" && echo 1 || echo 0)
    export CC=icc
    export CXX=icc
    export FC=ifort
    export F90=$FC
    export CFLAGS="-D__INTEL_COMPILER"
    export FFLAGS="-fPIC"
    export CXXFLAGS="-fPIC"
    export CCFLAGS="-lstdc++"
    export F90FLAGS=$FFLAGS
    export CONFIG_FLAGS=""
    export COMPILER_CONFIG="--enable-f90modules --with-romio"
%endif
# Pathscale compiler
%if %(test "%{compiler}" = "pathscale" && echo 1 || echo 0)
    export CC=pathcc
    export CXX=pathCC
    export FC=pathf90
    export F90=pathf90
    export F77=pathf90
    export CFLAGS=""
    export FFLAGS="-fPIC"
    export CXXFLAGS="-fPIC"
    export CCFLAGS=""
    export F90FLAGS=$FFLAGS
    export CONFIG_FLAGS=""
    export COMPILER_CONFIG="--enable-f90modules --with-romio"
%endif
# PGI compiler
%if %(test "%{compiler}" = "pgi" && echo 1 || echo 0)
    export CC=pgcc
    export CXX=pgCC
    export FC=pgf77
    export F90=pgf90
    export CFLAGS="-Msignextend -DPGI"
    export FFLAGS="-fPIC"
    export CXXFLAGS="-fPIC"
    export F90FLAGS=$FFLAGS
    export CONFIG_FLAGS=""
    export OPTIMIZATION_FLAG=""
%endif
# Sun Studio compiler
%if %(test "%{compiler}" = "sun" && echo 1 || echo 0)
    export CC=suncc
    export CXX=sunCC
    export F77=sunf77
    export F90=sunf90
    export CFLAGS=""
    export FFLAGS="-fPIC"
    export CXXFLAGS="-fPIC"
    export F90FLAGS=$FFLAGS
    export CONFIG_FLAGS=""
    export OPTIMIZATION_FLAG="-O3"
%endif

#############################################################################

EXTRA_CFLAG=$CFLAGS

# Customize your system architecture in ARCH_NAME
# "_IA32_" for i686, "_IA64_" for ia64, 
# "_X86_64_" for Opteron, "_EM64T_" for Intel EM64T
# "_PPC64_" for PowerPC 64
if [ -z $ARCH_NAME ]; then 
   if [ ! -z "`uname -m | grep 86 | grep -v 86_64`" ]; then
      # echo "x86"
      ARCH_NAME="-D_IA32_"
   elif [ ! -z "`uname -m | grep 64 | grep -v 86_64 | grep -v ppc64`" ]; then
      # echo "ia64"
      ARCH_NAME="-D_IA64_"
   elif [ ! -z "`uname -m | grep ppc64`" ]; then
      # echo "PPC64"
      ARCH_NAME="-D_PPC64_"
   elif [ ! -z "`uname -m | grep 86_64`" ]; then
      if [ ! -z "`cat /proc/cpuinfo | grep vendor | grep Intel`" ]; then
          # echo "em64t"
          ARCH_NAME="-D_EM64T_"
      else
          # echo "x86_64"
          ARCH_NAME="-D_X86_64_"
      fi
   fi
fi

# Special patch for PPC platform
if [ "$ARCH_NAME" == "-D_PPC64_" ]; then
    if [ "$CC" == "gcc" ]; then
        # Flag fixes for Fedora PPC
        CFLAGS="-m64 $CFLAGS"
        CXXFLAGS="-m64 $CXXFLAGS"
        CPPFLAGS="-m64 $CPPFLAGS"
        FFLAGS="-m64 $FFLAGS"
        F90FLAGS="-m64 $F90FLAGS"
        LDFLAGS="-m64 $LDFLAGS"
        USER_CFLAGS="-m64 $USER_CFLAGS"
        MPIRUN_CFLAGS="-m64 $MPIRUN_CFLAGS"
        MPE_FLAGS=-mpe_opts="--with-cflags=-m64 --with-fflags=-m64"
    fi
fi
# check for version
if [ -f $buildidfile ]; then
    buildid=`cat $buildidfile | grep MVAPICH_BUILDID |awk '{print $2}'`
    if [ "$buildid" != "" ];then
        DEF_BUILDID="$DEF_BUILDID -DMVAPICH_BUILDID=\\\"$buildid\\\""
    else
        DEF_BUILDID=""
    fi
fi

echo $ARCH_NAME | grep -v "\-D_IA64_" | grep -q 64 && BIT=64 &> /dev/null

if [[ "$ARCH_NAME" == "-D_IA64_" && (( -f /lib/ssa/libgcc_s.so ) || ( -f /usr/lib/libgcc_s.so )) ]]; then
    EXTRA_CFLAG=" -L/lib/ssa -L/usr/lib -lgcc_s"
fi

IB_INCLUDE=%{openib_prefix}/include
IB_LIB=%{openib_prefix}/lib${BIT}

export CFLAGS="$CFLAGS $OPTIMIZATION_FLAG -g -D_GNU_SOURCE -DCH_GEN2 -D_AFFINITY_ -DMEMORY_SCALE -D_SMP_ -D_SMP_RNDV_ -DVIADEV_RPUT_SUPPORT -DEARLY_SEND_COMPLETION -DXRC $ARCH_NAME -I$IB_INCLUDE"
export USER_CFLAGS
export MPE_OPTS
export MPE_CFLAGS
export LDFLAGS
export CXXFLAGS="$CXXFLAGS"
export FFLAGS="$FFLAGS -L$IB_LIB $EXTRA_CFLAG"
export F90FLAGS="$F90FLAGS $EXTRA_CFLAG"
export CONFIG_FLAGS
export MPIRUN_CFLAGS="$MPIRUN_CFLAGS -DPARAM_GLOBAL=\\\"%{_prefix}/etc/$conffile\\\" -DLD_LIBRARY_PATH_MPI=\\\"%{_prefix}/lib/shared\\\" -DMPI_PREFIX=\\\"%{_prefix}/\\\" $DEF_BUILDID"
./configure --enable-sharedlib --with-device=%{mpi_device} --with-arch=LINUX --prefix=$RPM_BUILD_ROOT%{_prefix} $CONFIG_ENABLE_F77 $CONFIG_ENABLE_F90 $COMPILER_CONFIG -lib="-L$IB_LIB -libverbs -libumad -lpthread $EXTRA_CFLAG" $MPE_FLAGS $CONFIG_FLAGS 
%{__make}

#############################################################################
# The real install
%{__make} install 

# Post install fixes
# Remove bad links
rm -f $RPM_BUILD_ROOT/%{_prefix}/share/examples/mpirun

# Creating environment scripts for sh/csh
# Script for sh
cat <<EOF > $RPM_BUILD_ROOT/%{_prefix}/bin/%{shell_scripts_basename}.sh
if ! echo \${PATH} | grep -q %{_prefix}/bin ; then
    export PATH=%{_prefix}/bin:\${PATH}
fi
if ! echo \${LD_LIBRARY_PATH} | grep -q %{_prefix}/lib ; then
    export LD_LIBRARY_PATH=%{_prefix}/lib:%{_prefix}/lib/shared:\${LD_LIBRARY_PATH}
fi
EOF

# Script for csh
cat <<EOF > $RPM_BUILD_ROOT/%{_prefix}/bin/%{shell_scripts_basename}.csh
if ("1" == "\$?path") then
    if ( "\${path}" !~ *%{_prefix}/bin* ) then
        setenv path %{_prefix}/bin:\$path
    endif
else
    setenv path %{_prefix}/bin:
endif

if ("1" == "\$?LD_LIBRARY_PATH") then
    if ("\$LD_LIBRARY_PATH" !~ *%{_prefix}/lib) then
        setenv LD_LIBRARY_PATH %{_prefix}/lib:%{_prefix}/lib/shared:\${LD_LIBRARY_PATH}
    endif
else
    setenv LD_LIBRARY_PATH %{_prefix}/lib:%{_prefix}/lib/shared
endif

EOF

#############################################################################
%clean
# Remove installed driver after rpm build finished
rm -rf $RPM_BUILD_DIR/mvapich-%{version}-%{release}

# Leave $RPM_BUILD_ROOT in order to build dependent packages, if desired
%if !%{leave_build_root}
test "x$RPM_BUILD_ROOT" != "x" && rm -rf $RPM_BUILD_ROOT
%endif

#############################################################################
%post
for file in `grep -r -l -I %{buildroot} %{_prefix}/*|grep -v :0|grep -v \\\.a|awk -F : '{print $1}'`;do
  perl -pi -e "s,%{buildroot},,g" $file
done
# Change and enable some defaults in mvapich.conf
perl -pi -e "s,^# VIADEV_DEFAULT_MIN_RNR_TIMER=12,VIADEV_DEFAULT_MIN_RNR_TIMER=25,g" %{_prefix}/etc/mvapich.conf
# Affinity should be disabled by default during runtime.
perl -pi -e "s,^# VIADEV_USE_AFFINITY=0,VIADEV_USE_AFFINITY=0,g" %{_prefix}/etc/mvapich.conf
# Disable Bcast-shmem code. The feature is broken.
perl -pi -e "s,^\# Please send your comments to mvapich-discuss\@cse\.ohio-state\.edu,VIADEV_USE_SHMEM_BCAST=0,g" %{_prefix}/etc/mvapich.conf
# mpi-selector stuff
%if %{use_mpi_selector}
%{mpi_selector} \
    --register %{name}-%{version} \
    --source-dir %{shell_scripts_path} \
        --yes
%endif

#############################################################################
%if %{use_mpi_selector}
%preun
%{mpi_selector} --unregister %{name}-%{version} --yes || \
      /bin/true > /dev/null 2> /dev/null
%endif

#############################################################################
#
# Files Section
#
#############################################################################

%files
%defattr(-, root, root, -)
%{_prefix}

#############################################################################
#
# Changelog
#
#############################################################################
%changelog
* Tue Oct  13 2009 Pavel Shamis <pasha@mellanox.co.il>
- Bug fixes for Fedora 10
* Wed Jun  24 2009 Pavel Shamis <pasha@mellanox.co.il>
- Changing "gcc --version" to "gcc -dumpversion"
* Thu Jun  11 2009 Pavel Shamis <pasha@mellanox.co.il>
- Removing "-libcommon"
* Mon Nov  24 2008 Pavel Shamis <pasha@mellanox.co.il>
- Disable runtime-affinity in mvapich.conf 
* Thu Nov  20 2008 Pavel Shamis <pasha@mellanox.co.il>
- Adding _AFFINITY_ 
* Sun Sep  21 2008 Pavel Shamis <pasha@mellanox.co.il>
- Disabling f90 bindings for gcc 3.X
* Mon May  12 2008 Pavel Shamis <pasha@mellanox.co.il>
- Fixes for mvapich 1.1 and OFED 1.4:
* Mon May  12 2008 Pavel Shamis <pasha@mellanox.co.il>
- Adding SUN compiler support
- Adding -fPIC to Pathscale, GCC and Intel
* Sun May  4 2008 Pavel Shamis <pasha@mellanox.co.il>
- Removing unused code
* Mon Jan  7 2008 Pavel Shamis <pasha@mellanox.co.il>
- Enable F90 build on PPC platforms
* Thu Dec  6 2007 Pavel Shamis <pasha@mellanox.co.il>
- Adding -fPIC compilation flag for pgi compiler
* Mon Dec  5 2007 Pavel Shamis <pasha@mellanox.co.il>
- Removing explicit Provides
- Replacing autoreqprov autoreq
* Mon Dec  3 2007 Pavel Shamis <pasha@mellanox.co.il>
- Fixing PGI 7.1 failure
* Wed Oct 31 2007 Pavel Shamis <pasha@mellanox.co.il>
- Adding support for mvapich 1.0.0 version
- Fixing mpi-selector bug
* Wed Aug 12 2007 Pavel Shamis <pasha@mellanox.co.il>
- Replacing default mvapich tunings with new values.
* Wed Jun  6 2007 Pavel Shamis <pasha@mellanox.co.il>
- Fixed PGI build bug. PGI doesn't support -Wall flag.
* Sun Mar 25 2007 Pavel Shamis <pasha@mellanox.co.il>
- Added support for mpi_compat_mode. 
* Wed Mar  8 2007 Pavel Shamis <pasha@mellanox.co.il>
- Intel compiler name was changed from icc to intel
* Tue Mar  6 2007 Pavel Shamis <pasha@mellanox.co.il>
- Fixed bug in mvapich.sh/csh generation.
* Thu Mar  1 2007 Pavel Shamis <pasha@mellanox.co.il>
- OFED section was moved before rpm definition section.
* Thu Mar  1 2007 Pavel Shamis <pasha@mellanox.co.il>
- OFED section was moved before rpm definition section.
* Thu Feb 20 2007 Pavel Shamis <pasha@mellanox.co.il>
- added support for mpi-selector
* Mon Feb  5 2007 Pavel Shamis <pasha@mellanox.co.il>
- the %build macro was removed,workaround for SUSE issue - %build removes $RPM_BUILD_ROOT
- added "-libcommon" for SuSe10
* Tue Jan 30 2007 Pavel Shamis <pasha@mellanox.co.il>
- The spec file was created
