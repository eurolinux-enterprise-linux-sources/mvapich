/* Copyright (c) 2008, Mellanox Technologis. All rights reserved. */

#ifndef _NR_H
#define _NR_H

#include <stdio.h>
#include "viapacket.h"
#include "viaparam.h"
#include "vbuf.h"
#include "viapriv.h"


//#define NR_ENABLED 1 /* set to 1 for Network Recovery mode */

extern uint8_t NR_ENABLED;

#define DEBUG00 200 /* No debug prints - It is default debug level */
#define DEBUG01 201 
#define DEBUG02 202
#define DEBUG03 203 /* Print All */

/* ch_gen2 layer debug prints are disabled by default. In order
 * to use the macro you need add -DVIADEV_DEBUG to CFLAGS
 */
#define NR_PRINT(fmt, args...)                                                                \
        {                                                                                     \
            fprintf(stderr, "[%d][(%s)%s:%d]", viadev.me, __FUNCTION__, __FILE__, __LINE__);  \
            fprintf(stderr, fmt, ## args);                                                    \
            fflush(stderr);                                                                   \
        }                                                                                     \

#ifdef VIADEV_DEBUG
#define V_PRINT(_dlevel, fmt, args...)                                      \
        if (_dlevel <= viadev_debug_level) {                                \
            fprintf(stderr, "[%d][(%s)%s:%d]", viadev.me, __FUNCTION__, __FILE__, __LINE__);  \
            fprintf(stderr, fmt, ## args);                                  \
            fflush(stderr);                                                 \
        }                                                                   \

#else

#define V_PRINT

#endif /* VIADEV_DEBUG */

#define NR_MAX_FAILURES 250
#define NR_DEFAULT_TIMEOUT_ON_ERROR 1000
#define NR_DEFAULT_TIMEOUT_ON_RESTART 1000

extern int nr_max_failures;
extern volatile int nr_fatal_error;
extern int nr_num_of_bad_connections;

#define WAITING_LIST_IS_EMPTY(list) (list->size > 0 ? 0 : 1)
#define NR_VBUF_IS_IB_COMPLETED(v) (1 == v->ib_completed)
#define NR_VBUF_IS_SW_COMPLETED(v) (1 == v->sw_completed)
#define WAITING_LIST_LEN(list) ((list)->size)
#define VBUF_TYPE(v) (((viadev_packet_header *) VBUF_BUFFER_START(v))->type)

typedef enum nr_qp_state {
    QP_DOWN,            /* QP in error state  */
    QP_REC,             /* QP was reconnected */
    QP_REC_D,           /* QP was reconnect was descovered */
    QP_UP               /* QP is ok           */
} nr_qp_state;

enum nr_message_type {
    NR_REQ = 1, /* NR reconnect request */
    NR_REP,     /* NR reply on reconnect request */
    NR_FIN,     /* NR FIN request - send after all RNDV retransmission */
};

enum nr_fatal {
    NO_FATAL, /* NR reconnect request */
    FATAL,     /* NR reply on reconnect request */
    IN_FATAL,     /* NR FIN request - send after all RNDV retransmission */
};

#define WAITING_LIST_INIT(list)                         \
    do {                                                \
        (list)->sentinel.next = &((list)->sentinel);    \
        (list)->sentinel.prev = &((list)->sentinel);    \
        (list)->size = 0;                               \
    } while(0)

#define WAITING_LIST_APPEND(list, v)        \
    do {                                    \
        (v)->prev = (list)->sentinel.prev;  \
        (v)->next = &(list)->sentinel;      \
        (list)->sentinel.prev->next = v;    \
        (list)->sentinel.prev = v;          \
        (list)->size++;                     \
    } while(0)

#define WAITING_LIST_REMOVE(list, v)            \
    do {                                        \
        assert(!WAITING_LIST_IS_EMPTY(list));   \
        ((v)->next)->prev = (v)->prev;          \
        ((v)->prev)->next = (v)->next;          \
         /* for debuf */                        \
        (v)->next = NULL;                       \
        (v)->prev = NULL;                       \
        (list)->size--;                         \
    } while(0);

#define WAITING_LIST_GET_FIRST(l) ((l)->sentinel.next)

#define WAITING_LIST_GET_LAST(l)  ((l)->sentinel.prev)

#define WAITING_LIST_GET_END(l)   (&(l)->sentinel)

#define NR_INCREASE_PENDING(c)      \
    do {                            \
        if (NR_ENABLED) {           \
            c->pending_acks++;      \
        }                           \
    } while(0)

#define NR_RELEASE(l, n)            \
    do {                            \
        if (NR_ENABLED && n > 0) {  \
            nr_release_acked(l, n); \
        }                           \
    } while (0)

#define NR_ADD_TO_LIST(l, v)        \
    do {                            \
        if (NR_ENABLED) {           \
            nr_add_to_list(l, v);   \
        }                           \
    } while(0)

#define NR_ADD_TO_LIST_FAST(l, v)                       \
    do {                                                \
        if (NR_ENABLED) {                               \
            WAITING_LIST_APPEND(l, v);                  \
        }                                               \
    } while(0)

#define NR_RNDV_ADD(l, r)                   \
    do {                                    \
        if (NR_ENABLED) {                   \
            WAITING_LIST_APPEND((l), r);    \
        }                                   \
    } while(0)                              \

#define NR_REMOVE_FROM_WAITING_LIST(l, r)   \
    do {                                    \
        if (NR_ENABLED) {                   \
            WAITING_LIST_REMOVE((l), r);    \
        }                                   \
    } while(0)                              \

#define PACKET_SET_HEADER_OPT(p, c, t)                              \
    do {                                                            \
        p->header.type = t;                                         \
        p->header.src_rank = viadev.me;                             \
        p->header.id   = c->next_packet_tosend++;                   \
    } while(0)

#define PACKET_SET_HEADER_NR(p, c, t)                               \
    do {                                                            \
        p->header.type = t;                                         \
        p->header.src_rank = viadev.me;                             \
        p->header.id   = c->next_packet_tosend++;                   \
        if (NR_ENABLED) {                                           \
            p->header.ack = c->pending_acks;                        \
            c->pending_acks = 0;                                    \
        }                                                           \
    } while(0)

#define NR_SET_ACK(h, c)              \
    do {                              \
        if (NR_ENABLED) {             \
            (h)->ack = c->pending_acks; \
            c->pending_acks = 0;      \
        }                             \
    } while(0)

#define PACKET_SET_HEADER_NR_R(p, c) {                          \
    p->header.type = VIADEV_PACKET_NOOP;                        \
    p->header.src_rank = viadev.me;                             \
    p->header.ack = c->next_packet_expected;                    \
    /* viadev_post_send will take the tail                      \
     * value from c->rdma_credit and will reset it */           \
    c->rdma_credit = c->p_RDMA_recv_tail;                       \
}

#define PACKET_SET_HEADER_NR_REQ(p, c) {                        \
    PACKET_SET_HEADER_NR_R(p, c)                                \
    p->header.id = NR_REQ;                                      \
}

#define PACKET_SET_HEADER_NR_REP(p, c) {                        \
    PACKET_SET_HEADER_NR_R(p, c)                                \
    p->header.id = NR_REP;                                      \
}

#define PACKET_SET_HEADER_NR_FIN(p, c) {                        \
    p->header.type = VIADEV_PACKET_NOOP;                        \
    p->header.src_rank = viadev.me;                             \
    p->header.id = NR_FIN;                                      \
    p->header.ack = 0;                                          \
}

#define PACKET_SET_HEADER_NOOP(p, c) {                          \
    p->header.type = VIADEV_PACKET_NOOP;                        \
    p->header.src_rank = viadev.me;                             \
    p->header.id = 0;                                           \
    if (NR_ENABLED) {                                           \
        p->header.ack = c->pending_acks;                        \
        c->pending_acks = 0;                                    \
    }                                                           \
}

#define IS_HEADER_CACHED(cached, h)                                                      \
    ((cached->header.vbuf_credit == h->header.vbuf_credit) &&                            \
     (cached->header.remote_credit == h->header.remote_credit) &&                        \
     (cached->header.rdma_credit == h->header.rdma_credit) &&                            \
     ((0 == NR_ENABLED ) || (1 == NR_ENABLED && cached->header.ack == h->header.ack)) && \
     (cached->envelope.context == h->envelope.context) &&                                \
     (cached->envelope.tag == h->envelope.tag) &&                                        \
     (cached->envelope.src_lrank == h->envelope.src_lrank))

#define NR_SEND_ACK_IFNEEDED(c)                                                         \
    do {                                                                                \
        if (NR_ENABLED && !c->progress_recov_mode && /*Pasha:need review the progress_recov*/\
                VIADEV_UNLIKELY(c->pending_acks > viadev_nr_ack_threshold)) {           \
                vbuf *v = get_vbuf();                                                   \
                viadev_packet_noop *p = (viadev_packet_noop *) VBUF_BUFFER_START(v);    \
                V_PRINT(DEBUG03, "NR %3d SEND NR ACK with %d credits\n", c->global_rank,\
                        c->pending_acks);                                               \
                PACKET_SET_HEADER_NOOP(p, c);                                           \
                vbuf_init_send(v, sizeof(viadev_packet_header));                        \
                viadev_post_send(c, v);                                                 \
        }                                                                               \
    } while (0)

#ifdef ADAPTIVE_RDMA_FAST_PATH
#ifdef XRC
#define FAST_PATH_ALLOC(c)                                                      \
    do {                                                                        \
        if (VIADEV_UNLIKELY(c->RDMA_recv_buf == NULL) && (c->initialized) &&    \
                (viadev_num_rdma_buffer > 0)) {                                 \
            if (viadev.RDMA_polling_group_size < viadev_rdma_eager_limit) {     \
                if (viadev.RDMA_polling_group_size < viadev_rdma_eager_limit) { \
                    c->eager_start_cnt = viadev_rdma_eager_threshold + 1;       \
                } else {                                                        \
                    c->eager_start_cnt++;                                       \
                }                                                               \
                if ((viadev_rdma_eager_threshold < c->eager_start_cnt) &&       \
                        !viadev.is_finalized) {                                 \
                    if (viadev_use_xrc && c->vi == NULL) {                      \
                        if (!(c->xrc_flags & XRC_FLAG_START_RDMAFP)) {          \
                            c->xrc_flags |= XRC_FLAG_START_RDMAFP;              \
                            MPICM_Connect_req (header->src_rank);               \
                        }                                                       \
                    }                                                           \
                    else                                                        \
                    {                                                           \
                        vbuf_fast_rdma_alloc(c, 1);                             \
                        vbuf_rdma_address_send(c);                              \
                    }                                                           \
                }                                                               \
            }                                                                   \
        }                                                                       \
    } while (0)
#else
#define FAST_PATH_ALLOC(c)                                                      \
    do {                                                                        \
        if (VIADEV_UNLIKELY(c->RDMA_recv_buf == NULL) && (c->initialized) &&    \
                (viadev_num_rdma_buffer > 0)) {                                 \
            if (viadev.RDMA_polling_group_size < viadev_rdma_eager_limit) {     \
                if (viadev.RDMA_polling_group_size < viadev_rdma_eager_limit) { \
                    c->eager_start_cnt = viadev_rdma_eager_threshold + 1;       \
                } else {                                                        \
                    c->eager_start_cnt++;                                       \
                }                                                               \
                if ((viadev_rdma_eager_threshold < c->eager_start_cnt) &&       \
                        !viadev.is_finalized) {                                 \
                    {                                                           \
                        vbuf_fast_rdma_alloc(c, 1);                             \
                        vbuf_rdma_address_send(c);                              \
                    }                                                           \
                }                                                               \
            }                                                                   \
        }                                                                       \
    } while (0)
#endif

#define DIRECT_POST_VBUF_RECV(peer)                                         \
    do {                                                                    \
        struct ibv_recv_wr *bad_wr;                                         \
        vbuf *v = get_vbuf();                                               \
        vbuf_init_recv(v, VBUF_BUFFER_SIZE);                                \
        v->grank = peer;                                                    \
        if(ibv_post_recv(viadev.qp_hndl[peer], &(v->desc.u.rr), &bad_wr)) { \
            error_abort_all(IBV_RETURN_ERR,                                 \
                    "Error posting direct recv\n");                         \
        }                                                                   \
    } while(0)

#endif

char* type2name(int type);
char* padding2name(int name);

void nr_init();
void nr_finalize();
void nr_process_retransmit (viadev_connection_t *c, viadev_packet_header *header);
void nr_incoming_nr_req (viadev_packet_header *h, viadev_connection_t *c);
void nr_incoming_nr_rep (viadev_packet_header *h, viadev_connection_t *c);
void nr_incoming_nr_fin (viadev_connection_t *c);
void nr_prepare_qp(int peer);
int nr_process_qp_error(struct ibv_wc *sc);
int nr_restart_hca ();

static inline void nr_try_to_release_ib_comp(vbuf *v)
{
    assert(v->ib_completed == 0);
    if (NR_VBUF_IS_SW_COMPLETED(v)){
#ifdef ADAPTIVE_RDMA_FAST_PATH
        if (v->padding == NORMAL_VBUF_FLAG) {
            release_vbuf(v);
        } else {
            v->padding = FREE_FLAG;
            v->len = 0;
        }
#else
        release_vbuf(v);
#endif
    } else {
        v->ib_completed = 1;
    }
}

static inline void nr_try_to_release_rndv_start(ack_list *list, vbuf *v)
{
    viadev_packet_header* h = (viadev_packet_header*)v->buffer;

    assert(0 == v->sw_completed);
    V_PRINT(DEBUG03, "NR: RNDV_FIN Releasing %s[%d] waiting list blen [%d] id:%d src:%d",
                type2name(VBUF_TYPE(v)), VBUF_TYPE(v), WAITING_LIST_LEN(list), h->id, h->src_rank);
    WAITING_LIST_REMOVE(list, v);
    V_PRINT(DEBUG03, "after len:%d \n",WAITING_LIST_LEN(list));

    if (NR_VBUF_IS_IB_COMPLETED(v)) {
        release_vbuf(v); /* otherway ib completen will release it */
        V_PRINT(DEBUG03, "NR: RNDV_FIN Releasing vbuf\n");
    } else {
        v->sw_completed = 1;
        V_PRINT(DEBUG03, "NR: RNDV_FIN waiting for ib ack\n");
    }
}

#define NR_RELEASE_RNDV_START(l, v)                 \
    do {                                            \
        if(NR_ENABLED) {                            \
            nr_try_to_release_rndv_start((l), (v)); \
        }                                           \
    } while(0) 

#ifdef ADAPTIVE_RDMA_FAST_PATH
#define RELEASE_VBUF(v)                             \
    if (NR_ENABLED) {                               \
        nr_try_to_release_ib_comp(v);               \
    } else {                                        \
        if (v->padding == NORMAL_VBUF_FLAG) {       \
            release_vbuf(v);                        \
        } else {                                    \
            v->padding = FREE_FLAG;                 \
            v->len = 0;                             \
        }                                           \
    }
#else
#define RELEASE_VBUF(v)                             \
    if (NR_ENABLED) {                               \
        nr_try_to_release_ib_comp(v);               \
    } else {                                        \
        release_vbuf(v);                            \
    }

#endif


static inline void nr_add_to_list(ack_list *list, vbuf *v)
{
    switch(VBUF_TYPE(v)) {
#ifndef DISABLE_HEADER_CACHING
        case FAST_EAGER_CACHED:
#endif
        case VIADEV_PACKET_EAGER_COALESCE:
        case VIADEV_PACKET_EAGER_START:
        case VIADEV_PACKET_EAGER_NEXT:
        case VIADEV_PACKET_RENDEZVOUS_START:
        case VIADEV_PACKET_RENDEZVOUS_REPLY: /* For R3 only */
        case VIADEV_PACKET_R3_DATA:
        case VIADEV_PACKET_R3_ACK:
            V_PRINT(DEBUG02, "NR: Packet %s[%d][%s] adding vbuf to waiting list len before [%d]\n",
                    type2name(VBUF_TYPE(v)), VBUF_TYPE(v), padding2name(v->padding), WAITING_LIST_LEN(list));
            WAITING_LIST_APPEND(list, v);
            V_PRINT(DEBUG03, " after [%d]\n",
                    WAITING_LIST_LEN(list));
            break;
        default:
            break;
    }
}

static inline void nr_release_acked(ack_list *list, const packet_sequence_t n)
{
    vbuf *v = NULL, *v_next = NULL;
    int i = n;
    assert(!WAITING_LIST_IS_EMPTY(list));
    V_PRINT(DEBUG03, "NR: Entering to release flow. list len - %d , pack to release - %d\n",
            WAITING_LIST_LEN(list), i);
    
    v_next = WAITING_LIST_GET_FIRST(list); /* I do not use for because in feature vbuf may be released */
    while(v_next != WAITING_LIST_GET_END(list) && i > 0) {
        v = v_next; 
        v_next = v_next->next;
        /* Randevouze will be releazed by fin message  or by reply message in case of R3 */
        if(VIADEV_PACKET_RENDEZVOUS_START == VBUF_TYPE(v)) {
            continue;
        }
#ifdef ADAPTIVE_RDMA_FAST_PATH
        /* fastpath will release by himself */
        if(!IS_NORMAL_VBUF(v)) {
            continue;
        }
#endif
        /* remove the vbuf from waiting for ack */  
        i--;
        WAITING_LIST_REMOVE(list, v);
        if (NR_VBUF_IS_IB_COMPLETED(v)) {
            release_vbuf(v); /* otherway ib completen will release it */
        } else {
            v->sw_completed = 1;
        }
        V_PRINT(DEBUG01, "NR: Released ACKED Packet %s[%d][%s] list len [%d]\n",
                type2name(VBUF_TYPE(v)), VBUF_TYPE(v), padding2name(v->padding), WAITING_LIST_LEN(list));
    }
    assert(0 == i);
}

#endif
