#!/usr/bin/env python3
import subprocess
import sys
import os

def get_git_info(path=None):
    """Get git information matching starship format"""
    if path:
        os.chdir(path)
    
    try:
        subprocess.run(['git', 'rev-parse', '--git-dir'], 
                      capture_output=True, check=True, timeout=1)
    except (subprocess.CalledProcessError, subprocess.TimeoutExpired):
        return ""
    
    git_info = []
    
    try:
        branch = subprocess.run(['git', 'branch', '--show-current'], 
                               capture_output=True, text=True, timeout=1)
        if branch.returncode == 0 and branch.stdout.strip():
            git_info.append(f"⎇ {branch.stdout.strip()}")
        else:
            commit = subprocess.run(['git', 'rev-parse', '--short', 'HEAD'], 
                                   capture_output=True, text=True, timeout=1)
            if commit.returncode == 0:
                git_info.append(f"⎇ {commit.stdout.strip()}")
    except subprocess.TimeoutExpired:
        pass
    
    try:
        status = subprocess.run(['git', 'status', '--porcelain'], 
                               capture_output=True, text=True, timeout=1)
        if status.returncode == 0:
            status_symbols = []
            lines = status.stdout.strip().split('\n')
            
            has_staged = False
            has_untracked = False
            has_clean_tracked = False
            
            if not lines or (len(lines) == 1 and not lines[0]):
                git_info.append("[✓]")
            else:
                for line in lines:
                    if not line:
                        continue
                        
                    staged = line[0] if len(line) > 0 else ' '
                    unstaged = line[1] if len(line) > 1 else ' '
                    
                    if staged == '?' and unstaged == '?':
                        has_untracked = True
                    elif staged in ['A', 'M', 'R', 'D']:
                        has_staged = True
                    elif staged == ' ' and unstaged in ['M', 'D']:
                        has_clean_tracked = True
                
                symbols = []
                if has_staged:
                    symbols.append('+')
                if has_untracked:
                    symbols.append('?')
                
                try:
                    ahead_behind = subprocess.run(['git', 'rev-list', '--left-right', '--count', 'HEAD...@{upstream}'], 
                                                capture_output=True, text=True, timeout=1)
                    if ahead_behind.returncode == 0:
                        counts = ahead_behind.stdout.strip().split()
                        if len(counts) == 2 and counts[0] == '0' and counts[1] == '0':
                            symbols.append('✓')  # Up to date with remote
                except:
                    symbols.append('✓')
                
                if symbols:
                    git_info.append(f"[{''.join(symbols)}]")
                else:
                    git_info.append("[✓]")
                
    except subprocess.TimeoutExpired:
        pass
    
    return " ".join(git_info)

if __name__ == "__main__":
    path = sys.argv[1] if len(sys.argv) > 1 else None
    print(get_git_info(path))
