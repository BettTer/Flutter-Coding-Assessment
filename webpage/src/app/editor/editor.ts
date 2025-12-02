import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-editor',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="h-[80vh] flex flex-col space-y-2">
      <div class="flex justify-between items-center">
        <h2 class="text-2xl font-bold text-slate-800">Knowledge Base</h2>
        <button (click)="save()" class="bg-blue-600 text-white px-4 py-1 rounded hover:bg-blue-700 transition font-medium">
          {{ isSaved ? 'Saved!' : 'Save' }}
        </button>
      </div>

      <div class="flex-1 flex gap-4 overflow-hidden">
        <!-- input -->
        <textarea 
          [(ngModel)]="content"
          class="flex-1 p-4 border rounded-lg resize-none focus:ring-2 focus:ring-blue-500 outline-none font-mono text-sm bg-white shadow-sm"
          placeholder="# Type markdown here..."></textarea>
        
        <!-- preview -->
        <div class="flex-1 p-4 bg-white border rounded-lg overflow-y-auto prose prose-sm shadow-sm">
          <div class="text-xs text-slate-400 uppercase mb-2 font-bold tracking-wider border-b pb-1">Preview</div>
          <!-- change wrap to <br> -->
          <div [innerHTML]="content.replace('\\n', '<br>')"></div>
        </div>
      </div>
    </div>
  `
})
export class EditorComponent {
  content = '# Welcome\n\nType something on the left to see the preview update instantly.\n\n- Point 1\n- Point 2';
  isSaved = false;

  save() {
    this.isSaved = true;
    setTimeout(() => this.isSaved = false, 2000);
  }
}