import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-tickets',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="space-y-4">
      <h2 class="text-2xl font-bold text-slate-800">Support Tickets</h2>
      
      <div class="bg-white rounded-lg shadow overflow-hidden">
        <table class="w-full text-left border-collapse">
          <thead class="bg-slate-100 text-slate-600 text-sm uppercase">
            <tr>
              <th class="p-3 border-b">ID</th>
              <th class="p-3 border-b">Subject</th>
              <th class="p-3 border-b">Status</th>
            </tr>
          </thead>
          <tbody class="text-sm">
            <tr *ngFor="let t of tickets" class="border-b hover:bg-slate-50">
              <td class="p-3 font-mono text-slate-500">#{{t.id}}</td>
              <td class="p-3 font-medium text-slate-700">{{t.subject}}</td>
              <td class="p-3">
                <span [class]="getStatusClass(t.status)">{{t.status}}</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  `
})
export class TicketsComponent {
  tickets = [
    { id: '1024', subject: 'No.1024 Ticket', status: 'Open' },
    { id: '1023', subject: 'No.1023 Ticket', status: 'In Progress' },
    { id: '1022', subject: 'No.1022 Ticket', status: 'Closed' },
    { id: '1021', subject: 'No.1021 Ticket', status: 'Open' },
    { id: '1020', subject: 'No.1020 Ticket', status: 'Open' },
  ];

  getStatusClass(status: string) {
    const base = 'px-2 py-1 rounded-full text-xs font-bold ';
    if (status === 'Open') return base + 'bg-red-100 text-red-700';
    if (status === 'In Progress') return base + 'bg-yellow-100 text-yellow-700';
    return base + 'bg-green-100 text-green-700';
  }
}