/** Copyright (C) 2019 IBM Corporation.
 *
 * Authors:
 * Frederico Araujo <frederico.araujo@ibm.com>
 * Teryl Taylor <terylt@ibm.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

#ifndef __SF_WRITER_
#define __SF_WRITER_
#include "avro/Compiler.hh"
#include "avro/DataFile.hh"
#include "avro/Decoder.hh"
#include "avro/Encoder.hh"
#include "avro/ValidSchema.hh"
#include "sysflow.h"
#include "sysflowcontext.h"
#include "utils.h"
#define COMPRESS_BLOCK_SIZE 80000

using sysflow::Container;
using sysflow::File;
using sysflow::FileEvent;
using sysflow::FileFlow;
using sysflow::NetworkFlow;
using sysflow::Process;
using sysflow::ProcessEvent;
using sysflow::SysFlow;

namespace writer {
class SysFlowWriter {
private:
  context::SysFlowContext *m_cxt;
  SysFlow m_flow;
  int m_numRecs{};
  avro::ValidSchema m_sysfSchema;
  avro::DataFileWriter<SysFlow> *m_dfw;
  void writeHeader();
  time_t m_start;
  string getFileName(time_t curTime);

public:
  SysFlowWriter(context::SysFlowContext *cxt, time_t start);
  virtual ~SysFlowWriter();
  inline int getNumRecs() { return m_numRecs; }
  inline void writeContainer(Container *container) {
    m_flow.rec.set_Container(*container);
    m_numRecs++;
    m_dfw->write(m_flow);
  }
  inline void writeProcess(Process *proc) {
    m_flow.rec.set_Process(*proc);
    m_numRecs++;
    m_dfw->write(m_flow);
  }
  inline void writeProcessEvent(ProcessEvent *pe) {
    m_flow.rec.set_ProcessEvent(*pe);
    m_numRecs++;
    m_dfw->write(m_flow);
  }
  inline void writeNetFlow(NetworkFlow *nf) {
    m_flow.rec.set_NetworkFlow(*nf);
    m_numRecs++;
    m_dfw->write(m_flow);
  }
  inline void writeFileFlow(FileFlow *ff) {
    m_flow.rec.set_FileFlow(*ff);
    m_numRecs++;
    m_dfw->write(m_flow);
  }
  inline void writeFileEvent(FileEvent *fe) {
    m_flow.rec.set_FileEvent(*fe);
    m_numRecs++;
    m_dfw->write(m_flow);
  }
  inline void writeFile(sysflow::File *f) {
    m_flow.rec.set_File(*f);
    m_numRecs++;
    m_dfw->write(m_flow);
  }
  inline bool isFileExpired(time_t curTime) {
    if (m_start > 0) {
      double duration = getDuration(curTime);
      return (duration >= m_cxt->getFileDuration());
    }
    return false;
  }
  inline double getDuration(time_t curTime) {
    return difftime(curTime, m_start);
  }
  int initialize();
  void resetFileWriter(time_t curTime);
};
} // namespace writer
#endif
