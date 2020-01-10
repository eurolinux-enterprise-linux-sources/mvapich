        MODULE MPI1__<type>_s
        IMPLICIT NONE
        PRIVATE
        PUBLIC :: MPI_ADDRESS
        INTERFACE MPI_ADDRESS
          MODULE PROCEDURE MPI_ADDRESS_T
        END INTERFACE ! MPI_ADDRESS

        PUBLIC :: MPI_BSEND
        INTERFACE MPI_BSEND
          MODULE PROCEDURE MPI_BSEND_T
        END INTERFACE ! MPI_BSEND

        PUBLIC :: MPI_BSEND_INIT
        INTERFACE MPI_BSEND_INIT
          MODULE PROCEDURE MPI_BSEND_INIT_T
        END INTERFACE ! MPI_BSEND_INIT

        PUBLIC :: MPI_BUFFER_ATTACH
        INTERFACE MPI_BUFFER_ATTACH
          MODULE PROCEDURE MPI_BUFFER_ATTACH_T
        END INTERFACE ! MPI_BUFFER_ATTACH

        PUBLIC :: MPI_BUFFER_DETACH
        INTERFACE MPI_BUFFER_DETACH
          MODULE PROCEDURE MPI_BUFFER_DETACH_T
        END INTERFACE ! MPI_BUFFER_DETACH

        PUBLIC :: MPI_IBSEND
        INTERFACE MPI_IBSEND
          MODULE PROCEDURE MPI_IBSEND_T
        END INTERFACE ! MPI_IBSEND

        PUBLIC :: MPI_IRECV
        INTERFACE MPI_IRECV
          MODULE PROCEDURE MPI_IRECV_T
        END INTERFACE ! MPI_IRECV

        PUBLIC :: MPI_IRSEND
        INTERFACE MPI_IRSEND
          MODULE PROCEDURE MPI_IRSEND_T
        END INTERFACE ! MPI_IRSEND

        PUBLIC :: MPI_ISEND
        INTERFACE MPI_ISEND
          MODULE PROCEDURE MPI_ISEND_T
        END INTERFACE ! MPI_ISEND

        PUBLIC :: MPI_ISSEND
        INTERFACE MPI_ISSEND
          MODULE PROCEDURE MPI_ISSEND_T
        END INTERFACE ! MPI_ISSEND

        PUBLIC :: MPI_RECV
        INTERFACE MPI_RECV
          MODULE PROCEDURE MPI_RECV_T
        END INTERFACE ! MPI_RECV

        PUBLIC :: MPI_RECV_INIT
        INTERFACE MPI_RECV_INIT
          MODULE PROCEDURE MPI_RECV_INIT_T
        END INTERFACE ! MPI_RECV_INIT

        PUBLIC :: MPI_RSEND
        INTERFACE MPI_RSEND
          MODULE PROCEDURE MPI_RSEND_T
        END INTERFACE ! MPI_RSEND

        PUBLIC :: MPI_RSEND_INIT
        INTERFACE MPI_RSEND_INIT
          MODULE PROCEDURE MPI_RSEND_INIT_T
        END INTERFACE ! MPI_RSEND_INIT

        PUBLIC :: MPI_SEND
        INTERFACE MPI_SEND
          MODULE PROCEDURE MPI_SEND_T
        END INTERFACE ! MPI_SEND

        PUBLIC :: MPI_SENDRECV_REPLACE
        INTERFACE MPI_SENDRECV_REPLACE
          MODULE PROCEDURE MPI_SENDRECV_REPLACE_T
        END INTERFACE ! MPI_SENDRECV_REPLACE

        PUBLIC :: MPI_SEND_INIT
        INTERFACE MPI_SEND_INIT
          MODULE PROCEDURE MPI_SEND_INIT_T
        END INTERFACE ! MPI_SEND_INIT

        PUBLIC :: MPI_SSEND
        INTERFACE MPI_SSEND
          MODULE PROCEDURE MPI_SSEND_T
        END INTERFACE ! MPI_SSEND

        PUBLIC :: MPI_SSEND_INIT
        INTERFACE MPI_SSEND_INIT
          MODULE PROCEDURE MPI_SSEND_INIT_T
        END INTERFACE ! MPI_SSEND_INIT

        PUBLIC :: MPI_BCAST
        INTERFACE MPI_BCAST
          MODULE PROCEDURE MPI_BCAST_T
        END INTERFACE ! MPI_BCAST

        PUBLIC :: MPI_SENDRECV
        INTERFACE MPI_SENDRECV
          MODULE PROCEDURE MPI_SENDRECV_T
        END INTERFACE ! MPI_SENDRECV

        PUBLIC :: MPI_ALLGATHER
        INTERFACE MPI_ALLGATHER
          MODULE PROCEDURE MPI_ALLGATHER_T
        END INTERFACE ! MPI_ALLGATHER

        PUBLIC :: MPI_ALLGATHERV
        INTERFACE MPI_ALLGATHERV
          MODULE PROCEDURE MPI_ALLGATHERV_T
        END INTERFACE ! MPI_ALLGATHERV

        PUBLIC :: MPI_ALLREDUCE
        INTERFACE MPI_ALLREDUCE
          MODULE PROCEDURE MPI_ALLREDUCE_T
        END INTERFACE ! MPI_ALLREDUCE

        PUBLIC :: MPI_ALLTOALL
        INTERFACE MPI_ALLTOALL
          MODULE PROCEDURE MPI_ALLTOALL_T
        END INTERFACE ! MPI_ALLTOALL

        PUBLIC :: MPI_ALLTOALLV
        INTERFACE MPI_ALLTOALLV
          MODULE PROCEDURE MPI_ALLTOALLV_T
        END INTERFACE ! MPI_ALLTOALLV

        PUBLIC :: MPI_GATHER
        INTERFACE MPI_GATHER
          MODULE PROCEDURE MPI_GATHER_T
        END INTERFACE ! MPI_GATHER

        PUBLIC :: MPI_GATHERV
        INTERFACE MPI_GATHERV
          MODULE PROCEDURE MPI_GATHERV_T
        END INTERFACE ! MPI_GATHERV

        PUBLIC :: MPI_REDUCE
        INTERFACE MPI_REDUCE
          MODULE PROCEDURE MPI_REDUCE_T
        END INTERFACE ! MPI_REDUCE

        PUBLIC :: MPI_REDUCE_SCATTER
        INTERFACE MPI_REDUCE_SCATTER
          MODULE PROCEDURE MPI_REDUCE_SCATTER_T
        END INTERFACE ! MPI_REDUCE_SCATTER

        PUBLIC :: MPI_SCAN
        INTERFACE MPI_SCAN
          MODULE PROCEDURE MPI_SCAN_T
        END INTERFACE ! MPI_SCAN

        PUBLIC :: MPI_SCATTER
        INTERFACE MPI_SCATTER
          MODULE PROCEDURE MPI_SCATTER_T
        END INTERFACE ! MPI_SCATTER

        PUBLIC :: MPI_SCATTERV
        INTERFACE MPI_SCATTERV
          MODULE PROCEDURE MPI_SCATTERV_T
        END INTERFACE ! MPI_SCATTERV

        CONTAINS
!
        SUBROUTINE MPI_ADDRESS_T(LOCATION, ADDRESS, IERROR)
        <type> LOCATION
        INTEGER  ADDRESS, IERROR
        EXTERNAL MPI_ADDRESS
        CALL MPI_ADDRESS(LOCATION, ADDRESS, IERROR)
        END SUBROUTINE MPI_ADDRESS_T
!
        SUBROUTINE MPI_BSEND_T(BUF, COUNT, DATATYPE, DEST, TAG, COMM,  &
      &   IERROR) 
        <type> BUF
        INTEGER  COUNT, DATATYPE, DEST, TAG, COMM, IERROR
        EXTERNAL MPI_BSEND
        CALL MPI_BSEND(BUF, COUNT, DATATYPE, DEST, TAG, COMM, IERROR)
        END SUBROUTINE MPI_BSEND_T
!
        SUBROUTINE MPI_BSEND_INIT_T(BUF, COUNT, DATATYPE, DEST, TAG,   &
      &   COMM, REQUEST, IERROR) 
        <type> BUF
        INTEGER  COUNT, DATATYPE, DEST, TAG, COMM, REQUEST, IERROR
        EXTERNAL MPI_BSEND_INIT
        CALL MPI_BSEND_INIT(BUF, COUNT, DATATYPE, DEST, TAG, COMM,     &
      &   REQUEST, IERROR) 
        END SUBROUTINE MPI_BSEND_INIT_T
!
        SUBROUTINE MPI_BUFFER_ATTACH_T( BUFFER, SIZE, IERROR)
        <type> BUFFER
        INTEGER  SIZE, IERROR
        EXTERNAL MPI_BUFFER_ATTACH
        CALL MPI_BUFFER_ATTACH( BUFFER, SIZE, IERROR)
        END SUBROUTINE MPI_BUFFER_ATTACH_T
!
        SUBROUTINE MPI_BUFFER_DETACH_T( BUFFER_ADDR, SIZE, IERROR)
        <type> BUFFER_ADDR
        INTEGER  SIZE, IERROR
        EXTERNAL MPI_BUFFER_DETACH
        CALL MPI_BUFFER_DETACH( BUFFER_ADDR, SIZE, IERROR)
        END SUBROUTINE MPI_BUFFER_DETACH_T
!
        SUBROUTINE MPI_IBSEND_T(BUF, COUNT, DATATYPE, DEST, TAG, COMM, &
      &   REQUEST, IERROR) 
        <type> BUF
        INTEGER  COUNT, DATATYPE, DEST, TAG, COMM, REQUEST, IERROR
        EXTERNAL MPI_IBSEND
        CALL MPI_IBSEND(BUF, COUNT, DATATYPE, DEST, TAG, COMM,         &
      &   REQUEST, IERROR) 
        END SUBROUTINE MPI_IBSEND_T
!
        SUBROUTINE MPI_IRECV_T(BUF, COUNT, DATATYPE, SOURCE, TAG,      &
      &   COMM, REQUEST, IERROR) 
        <type> BUF
        INTEGER  COUNT, DATATYPE, SOURCE, TAG, COMM, REQUEST, IERROR
        EXTERNAL MPI_IRECV
        CALL MPI_IRECV(BUF, COUNT, DATATYPE, SOURCE, TAG, COMM,        &
      &   REQUEST, IERROR) 
        END SUBROUTINE MPI_IRECV_T
!
        SUBROUTINE MPI_IRSEND_T(BUF, COUNT, DATATYPE, DEST, TAG, COMM, &
      &   REQUEST, IERROR) 
        <type> BUF
        INTEGER  COUNT, DATATYPE, DEST, TAG, COMM, REQUEST, IERROR
        EXTERNAL MPI_IRSEND
        CALL MPI_IRSEND(BUF, COUNT, DATATYPE, DEST, TAG, COMM,         &
      &   REQUEST, IERROR) 
        END SUBROUTINE MPI_IRSEND_T
!
        SUBROUTINE MPI_ISEND_T(BUF, COUNT, DATATYPE, DEST, TAG, COMM,  &
      &   REQUEST, IERROR) 
        <type> BUF
        INTEGER  COUNT, DATATYPE, DEST, TAG, COMM, REQUEST, IERROR
        EXTERNAL MPI_ISEND
        CALL MPI_ISEND(BUF, COUNT, DATATYPE, DEST, TAG, COMM, REQUEST, &
      &   IERROR) 
        END SUBROUTINE MPI_ISEND_T
!
        SUBROUTINE MPI_ISSEND_T(BUF, COUNT, DATATYPE, DEST, TAG, COMM, &
      &   REQUEST, IERROR) 
        <type> BUF
        INTEGER  COUNT, DATATYPE, DEST, TAG, COMM, REQUEST, IERROR
        EXTERNAL MPI_ISSEND
        CALL MPI_ISSEND(BUF, COUNT, DATATYPE, DEST, TAG, COMM,         &
      &   REQUEST, IERROR) 
        END SUBROUTINE MPI_ISSEND_T
!
        SUBROUTINE MPI_RECV_T(BUF, COUNT, DATATYPE, SOURCE, TAG, COMM, &
      &   STATUS, IERROR) 
        USE MPI_CONSTANTS,ONLY: MPI_STATUS_SIZE
        <type> BUF
        INTEGER  COUNT, DATATYPE, SOURCE, TAG, COMM,                   &
      &   STATUS(MPI_STATUS_SIZE), IERROR 
        EXTERNAL MPI_RECV
        CALL MPI_RECV(BUF, COUNT, DATATYPE, SOURCE, TAG, COMM, STATUS, &
      &   IERROR) 
        END SUBROUTINE MPI_RECV_T
!
        SUBROUTINE MPI_RECV_INIT_T(BUF, COUNT, DATATYPE, SOURCE, TAG,  &
      &   COMM, REQUEST, IERROR) 
        <type> BUF
        INTEGER  COUNT, DATATYPE, SOURCE, TAG, COMM, REQUEST, IERROR
        EXTERNAL MPI_RECV_INIT
        CALL MPI_RECV_INIT(BUF, COUNT, DATATYPE, SOURCE, TAG, COMM,    &
      &   REQUEST, IERROR) 
        END SUBROUTINE MPI_RECV_INIT_T
!
        SUBROUTINE MPI_RSEND_T(BUF, COUNT, DATATYPE, DEST, TAG, COMM,  &
      &   IERROR) 
        <type> BUF
        INTEGER  COUNT, DATATYPE, DEST, TAG, COMM, IERROR
        EXTERNAL MPI_RSEND
        CALL MPI_RSEND(BUF, COUNT, DATATYPE, DEST, TAG, COMM, IERROR)
        END SUBROUTINE MPI_RSEND_T
!
        SUBROUTINE MPI_RSEND_INIT_T(BUF, COUNT, DATATYPE, DEST, TAG,   &
      &   COMM, REQUEST, IERROR) 
        <type> BUF
        INTEGER  COUNT, DATATYPE, DEST, TAG, COMM, REQUEST, IERROR
        EXTERNAL MPI_RSEND_INIT
        CALL MPI_RSEND_INIT(BUF, COUNT, DATATYPE, DEST, TAG, COMM,     &
      &   REQUEST, IERROR) 
        END SUBROUTINE MPI_RSEND_INIT_T
!
        SUBROUTINE MPI_SEND_T(BUF, COUNT, DATATYPE, DEST, TAG, COMM,   &
      &   IERROR) 
        <type> BUF
        INTEGER  COUNT, DATATYPE, DEST, TAG, COMM, IERROR
        EXTERNAL MPI_SEND
        CALL MPI_SEND(BUF, COUNT, DATATYPE, DEST, TAG, COMM, IERROR)
        END SUBROUTINE MPI_SEND_T
!
        SUBROUTINE MPI_SENDRECV_REPLACE_T(BUF, COUNT, DATATYPE, DEST,  &
      &   SENDTAG, SOURCE, RECVTAG, COMM, STATUS, IERROR) 
        USE MPI_CONSTANTS,ONLY: MPI_STATUS_SIZE
        <type> BUF
        INTEGER COUNT, DATATYPE, DEST, SENDTAG, SOURCE, RECVTAG, COMM, &
      &   STATUS(MPI_STATUS_SIZE), IERROR 
        EXTERNAL MPI_SENDRECV_REPLACE
        CALL MPI_SENDRECV_REPLACE(BUF, COUNT, DATATYPE, DEST, SENDTAG, &
      &   SOURCE, RECVTAG, COMM, STATUS, IERROR) 
        END SUBROUTINE MPI_SENDRECV_REPLACE_T
!
        SUBROUTINE MPI_SEND_INIT_T(BUF, COUNT, DATATYPE, DEST, TAG,    &
      &   COMM, REQUEST, IERROR) 
        <type> BUF
        INTEGER  COUNT, DATATYPE, DEST, TAG, COMM, REQUEST, IERROR
        EXTERNAL MPI_SEND_INIT
        CALL MPI_SEND_INIT(BUF, COUNT, DATATYPE, DEST, TAG, COMM,      &
      &   REQUEST, IERROR) 
        END SUBROUTINE MPI_SEND_INIT_T
!
        SUBROUTINE MPI_SSEND_T(BUF, COUNT, DATATYPE, DEST, TAG, COMM,  &
      &   IERROR) 
        <type> BUF
        INTEGER  COUNT, DATATYPE, DEST, TAG, COMM, IERROR
        EXTERNAL MPI_SSEND
        CALL MPI_SSEND(BUF, COUNT, DATATYPE, DEST, TAG, COMM, IERROR)
        END SUBROUTINE MPI_SSEND_T
!
        SUBROUTINE MPI_SSEND_INIT_T(BUF, COUNT, DATATYPE, DEST, TAG,   &
      &   COMM, REQUEST, IERROR) 
        <type> BUF
        INTEGER  COUNT, DATATYPE, DEST, TAG, COMM, REQUEST, IERROR
        EXTERNAL MPI_SSEND_INIT
        CALL MPI_SSEND_INIT(BUF, COUNT, DATATYPE, DEST, TAG, COMM,     &
      &   REQUEST, IERROR) 
        END SUBROUTINE MPI_SSEND_INIT_T
!
        SUBROUTINE MPI_BCAST_T(BUFFER, COUNT, DATATYPE, ROOT, COMM,    &
      &   IERROR) 
        <type> BUFFER
        INTEGER COUNT, DATATYPE, ROOT, COMM, IERROR
        EXTERNAL MPI_BCAST
        CALL MPI_BCAST(BUFFER, COUNT, DATATYPE, ROOT, COMM, IERROR)
        END SUBROUTINE MPI_BCAST_T
!
        SUBROUTINE MPI_SENDRECV_T(SENDBUF, SENDCOUNT, SENDTYPE, DEST,  &
      &   SENDTAG, RECVBUF, RECVCOUNT, RECVTYPE, SOURCE, RECVTAG,      &
      &   COMM, STATUS, IERROR) 
        USE MPI_CONSTANTS,ONLY: MPI_STATUS_SIZE
        <type> SENDBUF, RECVBUF 
        INTEGER  SENDCOUNT, SENDTYPE, DEST, SENDTAG, RECVCOUNT,        &
      &   RECVTYPE, SOURCE, RECVTAG, COMM, STATUS(MPI_STATUS_SIZE),    &
      &   IERROR 
        EXTERNAL MPI_SENDRECV
        CALL MPI_SENDRECV(SENDBUF, SENDCOUNT, SENDTYPE, DEST, SENDTAG, &
      &   RECVBUF, RECVCOUNT, RECVTYPE, SOURCE, RECVTAG, COMM, STATUS, &
      &   IERROR) 
        END SUBROUTINE MPI_SENDRECV_T
!
        SUBROUTINE MPI_ALLGATHER_T(SENDBUF, SENDCOUNT, SENDTYPE,       &
      &   RECVBUF, RECVCOUNT, RECVTYPE, COMM, IERROR) 
        <type> SENDBUF, RECVBUF 
        INTEGER SENDCOUNT, SENDTYPE, RECVCOUNT, RECVTYPE, COMM, IERROR
        EXTERNAL MPI_ALLGATHER
        CALL MPI_ALLGATHER(SENDBUF, SENDCOUNT, SENDTYPE, RECVBUF,      &
      &   RECVCOUNT, RECVTYPE, COMM, IERROR) 
        END SUBROUTINE MPI_ALLGATHER_T
!
        SUBROUTINE MPI_ALLGATHERV_T(SENDBUF, SENDCOUNT, SENDTYPE,      &
      &   RECVBUF, RECVCOUNTS, DISPLS, RECVTYPE, COMM, IERROR) 
        <type> SENDBUF, RECVBUF 
        INTEGER SENDCOUNT, SENDTYPE, RECVCOUNTS(*), DISPLS(*),         &
      &   RECVTYPE, COMM, IERROR 
        EXTERNAL MPI_ALLGATHERV
        CALL MPI_ALLGATHERV(SENDBUF, SENDCOUNT, SENDTYPE, RECVBUF,     &
      &   RECVCOUNTS, DISPLS, RECVTYPE, COMM, IERROR) 
        END SUBROUTINE MPI_ALLGATHERV_T
!
        SUBROUTINE MPI_ALLREDUCE_T(SENDBUF, RECVBUF, COUNT, DATATYPE,  &
      &   OP, COMM, IERROR) 
        <type> SENDBUF, RECVBUF 
        INTEGER COUNT, DATATYPE, OP, COMM, IERROR
        EXTERNAL MPI_ALLREDUCE
        CALL MPI_ALLREDUCE(SENDBUF, RECVBUF, COUNT, DATATYPE, OP,      &
      &   COMM, IERROR) 
        END SUBROUTINE MPI_ALLREDUCE_T
!
        SUBROUTINE MPI_ALLTOALL_T(SENDBUF, SENDCOUNT, SENDTYPE,        &
      &   RECVBUF, RECVCOUNT, RECVTYPE, COMM, IERROR) 
        <type> SENDBUF, RECVBUF 
        INTEGER SENDCOUNT, SENDTYPE, RECVCOUNT, RECVTYPE, COMM, IERROR
        EXTERNAL MPI_ALLTOALL
        CALL MPI_ALLTOALL(SENDBUF, SENDCOUNT, SENDTYPE, RECVBUF,       &
      &   RECVCOUNT, RECVTYPE, COMM, IERROR) 
        END SUBROUTINE MPI_ALLTOALL_T
!
        SUBROUTINE MPI_ALLTOALLV_T(SENDBUF, SENDCOUNTS, SDISPLS,       &
      &   SENDTYPE, RECVBUF, RECVCOUNTS, RDISPLS, RECVTYPE, COMM,      &
      &   IERROR) 
        <type> SENDBUF, RECVBUF 
        INTEGER SENDCOUNTS(*), SDISPLS(*), SENDTYPE, RECVCOUNTS(*),    &
      &   RDISPLS(*), RECVTYPE, COMM, IERROR 
        EXTERNAL MPI_ALLTOALLV
        CALL MPI_ALLTOALLV(SENDBUF, SENDCOUNTS, SDISPLS, SENDTYPE,     &
      &   RECVBUF, RECVCOUNTS, RDISPLS, RECVTYPE, COMM, IERROR) 
        END SUBROUTINE MPI_ALLTOALLV_T
!
        SUBROUTINE MPI_GATHER_T(SENDBUF, SENDCOUNT, SENDTYPE, RECVBUF, &
      &   RECVCOUNT, RECVTYPE, ROOT, COMM, IERROR) 
        <type> SENDBUF, RECVBUF 
        INTEGER SENDCOUNT, SENDTYPE, RECVCOUNT, RECVTYPE, ROOT, COMM,  &
      &   IERROR 
        EXTERNAL MPI_GATHER
        CALL MPI_GATHER(SENDBUF, SENDCOUNT, SENDTYPE, RECVBUF,         &
      &   RECVCOUNT, RECVTYPE, ROOT, COMM, IERROR) 
        END SUBROUTINE MPI_GATHER_T
!
        SUBROUTINE MPI_GATHERV_T(SENDBUF, SENDCOUNT, SENDTYPE,         &
      &   RECVBUF, RECVCOUNTS, DISPLS, RECVTYPE, ROOT, COMM, IERROR) 
        <type> SENDBUF, RECVBUF 
        INTEGER SENDCOUNT, SENDTYPE, RECVCOUNTS(*), DISPLS(*),         &
      &   RECVTYPE, ROOT, COMM, IERROR 
        EXTERNAL MPI_GATHERV
        CALL MPI_GATHERV(SENDBUF, SENDCOUNT, SENDTYPE, RECVBUF,        &
      &   RECVCOUNTS, DISPLS, RECVTYPE, ROOT, COMM, IERROR) 
        END SUBROUTINE MPI_GATHERV_T
!
        SUBROUTINE MPI_REDUCE_T(SENDBUF, RECVBUF, COUNT, DATATYPE, OP, &
      &   ROOT, COMM, IERROR) 
        <type> SENDBUF, RECVBUF 
        INTEGER COUNT, DATATYPE, OP, ROOT, COMM, IERROR
        EXTERNAL MPI_REDUCE
        CALL MPI_REDUCE(SENDBUF, RECVBUF, COUNT, DATATYPE, OP, ROOT,   &
      &   COMM, IERROR) 
        END SUBROUTINE MPI_REDUCE_T
!
        SUBROUTINE MPI_REDUCE_SCATTER_T(SENDBUF, RECVBUF, RECVCOUNTS,  &
      &   DATATYPE, OP, COMM, IERROR) 
        <type> SENDBUF, RECVBUF 
        INTEGER RECVCOUNTS(*), DATATYPE, OP, COMM, IERROR
        EXTERNAL MPI_REDUCE_SCATTER
        CALL MPI_REDUCE_SCATTER(SENDBUF, RECVBUF, RECVCOUNTS,          &
      &   DATATYPE, OP, COMM, IERROR) 
        END SUBROUTINE MPI_REDUCE_SCATTER_T
!
        SUBROUTINE MPI_SCAN_T(SENDBUF, RECVBUF, COUNT, DATATYPE, OP,   &
      &   COMM, IERROR) 
        <type> SENDBUF, RECVBUF 
        INTEGER COUNT, DATATYPE, OP, COMM, IERROR
        EXTERNAL MPI_SCAN
        CALL MPI_SCAN(SENDBUF, RECVBUF, COUNT, DATATYPE, OP, COMM,     &
      &   IERROR) 
        END SUBROUTINE MPI_SCAN_T
!
        SUBROUTINE MPI_SCATTER_T(SENDBUF, SENDCOUNT, SENDTYPE,         &
      &   RECVBUF, RECVCOUNT, RECVTYPE, ROOT, COMM, IERROR) 
        <type> SENDBUF, RECVBUF 
        INTEGER SENDCOUNT, SENDTYPE, RECVCOUNT, RECVTYPE, ROOT, COMM,  &
      &   IERROR 
        EXTERNAL MPI_SCATTER
        CALL MPI_SCATTER(SENDBUF, SENDCOUNT, SENDTYPE, RECVBUF,        &
      &   RECVCOUNT, RECVTYPE, ROOT, COMM, IERROR) 
        END SUBROUTINE MPI_SCATTER_T
!
        SUBROUTINE MPI_SCATTERV_T(SENDBUF, SENDCOUNTS, DISPLS,         &
      &   SENDTYPE, RECVBUF, RECVCOUNT, RECVTYPE, ROOT, COMM, IERROR) 
        <type> SENDBUF, RECVBUF 
        INTEGER SENDCOUNTS(*), DISPLS(*), SENDTYPE, RECVCOUNT,         &
      &   RECVTYPE, ROOT, COMM, IERROR 
        EXTERNAL MPI_SCATTERV
        CALL MPI_SCATTERV(SENDBUF, SENDCOUNTS, DISPLS, SENDTYPE,       &
      &   RECVBUF, RECVCOUNT, RECVTYPE, ROOT, COMM, IERROR) 
        END SUBROUTINE MPI_SCATTERV_T
        END MODULE MPI1__<type>_s
