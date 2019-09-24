#ifndef _SF_FILE_EVT
#define _SF_FILE_EVT
/** Copyright (C) 2019 IBM Corporation.
*
* Authors:
* Teryl Taylor <terylt@ibm.com>
* Frederico Araujo <frederico.araujo@ibm.com>
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

#include <sinsp.h>
#include "sysflowwriter.h"
#include "processcontext.h"
#include "filecontext.h"
#include "sysflow.h"
#include "utils.h"
#include "syscall_defs.h"
#include "file_types.h"
#include "logger.h"
using namespace sysflow;
namespace fileevent {


    class FileEventProcessor {
        private:
            process::ProcessContext* m_processCxt;
            SysFlowWriter* m_writer;
            file::FileContext* m_fileCxt;
            FileEvent m_fileEvt;
            int writeFileEvent(sinsp_evt* ev, OpFlags flag);
            int writeLinkEvent(sinsp_evt* ev, OpFlags flag);
            DEFINE_LOGGER();
        public:
            FileEventProcessor(SysFlowWriter* writer, process::ProcessContext* procCxt, file::FileContext* fileCxt);
            virtual ~FileEventProcessor();
            int handleFileFlowEvent(sinsp_evt* ev, OpFlags flag);
                 

    };

}
#endif
