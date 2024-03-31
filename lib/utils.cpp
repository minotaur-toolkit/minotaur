// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "utils.h"

#include "llvm/Transforms/Scalar/DCE.h"
#include "llvm/Passes/PassBuilder.h"

#include "hiredis.h"

#include <unordered_set>

using namespace std;
using namespace llvm;

namespace minotaur {

void eliminate_dead_code(Function &F) {
  FunctionAnalysisManager FAM;

  PassBuilder PB;
  PB.registerFunctionAnalyses(FAM);

  FunctionPassManager FPM;
  FPM.addPass(DCEPass());
  FPM.run(F, FAM);
}

bool hGet(const char* s, unsigned sz, string &Value, redisContext *c) {
  redisReply *reply = (redisReply *)redisCommand(c, "HGET %b rewrite", s, sz);
  if (!reply || c->err) {
    report_fatal_error((StringRef)"redis error" + c->errstr);
  }
  if (reply->type == REDIS_REPLY_NIL) {
    freeReplyObject(reply);
    return false;
  } else if (reply->type == REDIS_REPLY_STRING) {
    Value = reply->str;
    freeReplyObject(reply);
    return true;
  } else {
    report_fatal_error((StringRef)
      "Redis protocol error for cache lookup, didn't expect reply type " +
      to_string(reply->type));
  }
}

void hSetRewrite(const char *k, unsigned sz_k,
                 const char *v, unsigned sz_v,
                 StringRef rewrite,
                 redisContext *c,
                 unsigned costAfter, unsigned costBefore, StringRef FnName) {
  redisReply *reply = (redisReply *)redisCommand(c,
    "HSET %b rewrite %s  costafter %s costbefore %s timestamp %s fn %s",
    k, sz_k, rewrite.data(),
    to_string(costAfter).c_str(), to_string(costBefore).c_str(),
    to_string((unsigned long)time(NULL)).c_str(), FnName.data());
  if (!reply || c->err)
    report_fatal_error((StringRef)"Redis error: " + c->errstr);
  if (reply->type != REDIS_REPLY_INTEGER) {
    report_fatal_error((StringRef)
      "Redis protocol error for cache fill, didn't expect reply type " +
      to_string(reply->type));
  }
  freeReplyObject(reply);
}

void hSetNoSolution(const char *k, unsigned sz_k,
                    redisContext *c,
                    StringRef FnName) {
  redisReply *reply = (redisReply *)redisCommand(c,
    "HSET %b rewrite <no-sol> timestamp %s fn %s",
    k, sz_k, to_string((unsigned long)time(NULL)).c_str(), FnName.data());
  if (!reply || c->err)
    report_fatal_error((StringRef)"Redis error: " + c->errstr);
  if (reply->type != REDIS_REPLY_INTEGER) {
    report_fatal_error((StringRef)
      "Redis protocol error for cache fill, didn't expect reply type " +
      to_string(reply->type));
  }
  freeReplyObject(reply);
}

void removeUnusedDecls(unordered_set<Function *> IntrinsicDecls) {
  for (auto Intr : IntrinsicDecls) {
    if (Intr->isDeclaration() && Intr->use_empty()) {
      Intr->eraseFromParent();
    }
  }
}

}