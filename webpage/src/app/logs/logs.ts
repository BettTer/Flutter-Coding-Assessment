import { Component, OnInit, OnDestroy, ElementRef, ViewChild, AfterViewChecked, ChangeDetectorRef } from '@angular/core'; 
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-logs',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="bg-slate-900 text-green-400 font-mono text-xs p-4 rounded-lg shadow-xl h-[80vh] flex flex-col border border-slate-700">
      <div class="flex justify-between items-center border-b border-slate-700 pb-2 mb-2">
        <span class="font-bold text-white tracking-widest">SYSTEM.LOG</span>
        <div class="flex items-center space-x-2">
          <span class="animate-pulse w-2 h-2 rounded-full bg-green-500"></span>
          <span class="text-green-500 font-bold">LIVE</span>
        </div>
      </div>

      <div #logContainer class="flex-1 overflow-y-auto space-y-1">
        <div *ngFor="let log of logs" class="hover:bg-slate-800 px-1 rounded transition-colors">
          <span class="text-slate-500 mr-2">[{{log.time}}]</span>
          
          <span [class.text-red-500]="log.type === 'ERR'" 
                [class.text-yellow-400]="log.type === 'WARN'"
                [class.text-blue-400]="log.type === 'INFO'"
                [class.text-green-400]="log.type === 'SUCCESS'">
            {{log.message}}
          </span>
        </div>
        
        <div *ngIf="logs.length === 0" class="text-slate-600 italic p-2">
          Initializing system monitors...
        </div>
      </div>
    </div>
  `
})
export class LogsComponent implements OnInit, OnDestroy, AfterViewChecked {
  @ViewChild('logContainer') private logContainer!: ElementRef;
  
  logs: Array<{time: string, type: string, message: string}> = [];
  intervalId: any;

  // 2. inject ChangeDetectorRef
  constructor(private cdr: ChangeDetectorRef) {} 

  ngOnInit() {
    this.addLog('System initialized...', 'SUCCESS');

    this.intervalId = setInterval(() => {
      this.generateLog();
    }, 1000);
  }

  ngOnDestroy() {
    if (this.intervalId) clearInterval(this.intervalId);
  }

  ngAfterViewChecked() {
    this.scrollToBottom();
  }

  scrollToBottom(): void {
    try {
      if (this.logContainer) {
        this.logContainer.nativeElement.scrollTop = this.logContainer.nativeElement.scrollHeight;
      }
    } catch(err) { }
  }

  generateLog() {
    const actions = ['GET /api/v1/auth', 'DB Connection', 'Cache Hit', 'User Login', 'File Upload'];
    const types = ['INFO', 'INFO', 'WARN', 'ERR', 'SUCCESS'];
    
    const type = types[Math.floor(Math.random() * types.length)];
    const action = actions[Math.floor(Math.random() * actions.length)];
    const id = Math.random().toString(36).substring(7).toUpperCase();
    
    this.addLog(`${action} [ID:${id}]`, type);
  }

  addLog(message: string, type: string) {
    const time = new Date().toLocaleTimeString();
    
    // update
    this.logs = [...this.logs, { time, type, message }];
    
    if (this.logs.length > 50) {
      this.logs = this.logs.slice(1); 
    }

    // trigger
    this.cdr.detectChanges(); 

    setTimeout(() => {
      this.scrollToBottom();
    }, 0);
  }
}