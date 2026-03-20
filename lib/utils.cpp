// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "utils.h"

#include "llvm/IR/Instructions.h"
#include "llvm/Transforms/Utils/Local.h"

#include "hiredis.h"

#include <cstdlib>
#include <unordered_set>

using namespace std;
using namespace llvm;

namespace minotaur {

static StringRef getCacheVersion() {
  if (const char *Env = std::getenv("MINOTAUR_CACHE_VERSION")) {
    if (*Env) {
      return Env;
    }
  }
  return "2";
}

void eliminate_dead_code(Function &F) {
  bool changed = true;
  while (changed) {
    changed = false;
    for (auto &BB : F) {
      for (auto it = BB.begin(); it != BB.end(); ) {
        Instruction *I = &*it++;
        if (isInstructionTriviallyDead(I)) {
          I->eraseFromParent();
          changed = true;
        }
      }
    }
  }
}

bool hGet(const char* s, unsigned sz, string &Value, redisContext *c) {
  redisReply *reply = (redisReply *)redisCommand(c,
    "HMGET %b rewrite version", s, sz);
  if (!reply || c->err) {
    report_fatal_error((StringRef)"redis error" + c->errstr);
  }

  if (reply->type != REDIS_REPLY_ARRAY || reply->elements != 2) {
    report_fatal_error((StringRef)
      "Redis protocol error for cache lookup, didn't expect reply type " +
      to_string(reply->type));
  }

  redisReply *rewrite = reply->element[0];
  redisReply *version = reply->element[1];
  if (!rewrite || rewrite->type == REDIS_REPLY_NIL) {
    freeReplyObject(reply);
    return false;
  }

  if (rewrite->type != REDIS_REPLY_STRING) {
    report_fatal_error((StringRef)
      "Redis protocol error for cache lookup, didn't expect rewrite reply type " +
      to_string(rewrite->type));
  }

  if (!version || version->type == REDIS_REPLY_NIL) {
    freeReplyObject(reply);
    return false;
  }

  if (version->type != REDIS_REPLY_STRING) {
    report_fatal_error((StringRef)
      "Redis protocol error for cache lookup, didn't expect version reply type " +
      to_string(version->type));
  }

  if (StringRef(version->str) != getCacheVersion()) {
    freeReplyObject(reply);
    return false;
  }

  Value = rewrite->str;
  freeReplyObject(reply);
  return true;
}

void hSetRewrite(const char *k, unsigned sz_k,
                 const char *v, unsigned sz_v,
                 StringRef rewrite,
                 redisContext *c,
                 unsigned costAfter, unsigned costBefore, StringRef FnName) {
  redisReply *reply = (redisReply *)redisCommand(c,
    "HSET %b rewrite %s costafter %s costbefore %s timestamp %s fn %s version %s",
    k, sz_k, rewrite.data(),
    to_string(costAfter).c_str(), to_string(costBefore).c_str(),
    to_string((unsigned long)time(NULL)).c_str(), FnName.data(),
    getCacheVersion().data());
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
    "HSET %b rewrite <no-sol> timestamp %s fn %s version %s",
    k, sz_k, to_string((unsigned long)time(NULL)).c_str(),
    FnName.data(), getCacheVersion().data());
  if (!reply || c->err)
    report_fatal_error((StringRef)"Redis error: " + c->errstr);
  if (reply->type != REDIS_REPLY_INTEGER) {
    report_fatal_error((StringRef)
      "Redis protocol error for cache fill, didn't expect reply type " +
      to_string(reply->type));
  }
  freeReplyObject(reply);
  // static profile
  reply = (redisReply *)redisCommand(c, "HINCRBY %b profile 1", k, sz_k);
  if (!reply || c->err)
    report_fatal_error((StringRef)"Redis error: " + c->errstr);
  if (reply->type != REDIS_REPLY_INTEGER) {
    report_fatal_error((StringRef)
      "Redis protocol error for cache fill, didn't expect reply type " +
      to_string(reply->type));
  }
  freeReplyObject(reply);
}

void removeUnusedDecls(const unordered_set<Function *> &IntrinsicDecls) {
  for (auto Intr : IntrinsicDecls) {
    if (Intr->isDeclaration() && Intr->use_empty()) {
      Intr->eraseFromParent();
    }
  }
}

}
