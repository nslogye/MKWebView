//
//  DFWGCDSafetyBlock.m
//  NMGuide
//
//  Created by lianggq on 2018/3/19.
//  Copyright © 2018年 liang. All rights reserved.
//

#import "DFWGCDSafetyBlock.h"

void dispatch_sync_safe(dispatch_queue_t queue, const void *tag, dispatch_block_t block) {
    if (dispatch_get_specific(tag)) {
        block();
    } else {
        dispatch_sync(queue, block);
    }
}


void dispatch_async_safe(dispatch_queue_t queue, const void *tag, dispatch_block_t block) {
    if (dispatch_get_specific(tag)) {
        block();
    } else {
        dispatch_async(queue, block);
    }
}

void dispatch_global_main(dispatch_block_t globalBlock, dispatch_block_t mainBlock) {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        globalBlock();
        dispatch_async(dispatch_get_main_queue(), ^{
            mainBlock();
        });
    });
}

void global_thread(dispatch_block_t globalBlock) {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        globalBlock();
    });
}

void main_async_thread(dispatch_block_t mainBlock) {
    dispatch_async(dispatch_get_main_queue(), ^{
        mainBlock();
    });
}

void dispatch_async_main_safe(dispatch_block_t mainBlock){
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        mainBlock();
    } else {
        dispatch_async(dispatch_get_main_queue(), mainBlock);
    }
}
