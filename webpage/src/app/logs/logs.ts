import { Component, OnInit, OnDestroy, ElementRef, ViewChild, AfterViewChecked } from '@angular/core';
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

      <!-- scroll zone -->
      <div #logContainer class="flex-1 overflow-y-auto space-y-1 scroll-smooth">
        <div *ngFor="let log of logs" class="hover:bg-slate-800 px-1 rounded">
          <span class="text-slate-500 mr-2">[{{log.time}}]</span>
          <span [class.text-red-400]="log.type === 'ERR'" 
                [class.text-yellow-400]="log.type === 'WARN'"
                [class.text-blue-400]="log.type === 'INFO'">
            {{log.message}}
          </span>
        </div>
      </div>
    </div>
  `
})
export class LogsComponent implements OnInit, OnDestroy, AfterViewChecked {
  @ViewChild('logContainer') private logContainer!: ElementRef;
  logs: any[] = [];
  intervalId: any;

  ngOnInit() {
    this.addLog('System initialized...', 'INFO');
    // make fake data
    this.intervalId = setInterval(() => this.generateLog(), 1500);
  }

  ngOnDestroy() {
    if (this.intervalId) clearInterval(this.intervalId);
  }

  ngAfterViewChecked() {
    this.scrollToBottom();
  }

  scrollToBottom(): void {
    try {
      this.logContainer.nativeElement.scrollTop = this.logContainer.nativeElement.scrollHeight;
    } catch(err) { }
  }

  generateLog() {
    const actions = ['GET /api/v1/messages', 'DB Connection Pool', 'Cache Miss', 'User Auth Success', 'Image Upload'];
    const types = ['INFO', 'INFO', 'INFO', 'WARN', 'ERR'];
    
    const type = types[Math.floor(Math.random() * types.length)];
    const action = actions[Math.floor(Math.random() * actions.length)];
    const id = Math.random().toString(36).substring(7).toUpperCase();
    
    this.addLog(`${action} [ID:${id}]`, type);
  }

  addLog(message: string, type: string) {
    const time = new Date().toLocaleTimeString();
    this.logs.push({ time, type, message });
    if (this.logs.length > 100) this.logs.shift(); 
  }
}