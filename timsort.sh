#!/bin/bash

# Global array
declare -a arr

# Function to perform insertion sort on a portion of the array
insertion_sort() {
    local start=$1
    local end=$2

    for ((i = start + 1; i <= end; i++)); do
        key="${arr[$i]}"
        j=$((i - 1))

        # Ensure that j doesn't go below start
        while ((j >= start && arr[j] > key)); do
            arr[$((j + 1))]=${arr[$j]}
            ((j--))
        done

        # Check to prevent bad array subscript
        if ((j + 1 >= start)); then
            arr[$((j + 1))]=$key
        fi
    done
}

# Function to perform merge operation on two portions of the array
merge() {
    local start=$1
    local mid=$2
    local end=$3

    local n1=$((mid - start + 1))
    local n2=$((end - mid))
    local left=("${arr[@]:start:n1}")
    local right=("${arr[@]:mid+1:n2}")
    local k=$start

    local i=0 j=0
    while ((i < n1 && j < n2)); do
        if [[ ${left[i]} -le ${right[j]} ]]; then
            arr[k]=${left[i]}
            ((i++))
        else
            arr[k]=${right[j]}
            ((j++))
        fi
        ((k++))
    done

    while ((i < n1)); do
        arr[k]=${left[i]}
        ((i++))
        ((k++))
    done

    while ((j < n2)); do
        arr[k]=${right[j]}
        ((j++))
        ((k++))
    done
}

# Function to perform Tim Sort
tim_sort() {
    local min_run=32
    local len=${#arr[@]}

    # Sort individual subarrays of size min_run
    for ((i = 0; i < len; i += min_run)); do
        local run_end=$((i + min_run - 1))
        ((run_end > len - 1)) && run_end=$((len - 1))

        insertion_sort $i $run_end
    done

    local run_len=$min_run
    while ((run_len < len)); do
        for ((i = 0; i < len; i += 2 * run_len)); do
            local left_end=$((i + run_len - 1))
            ((left_end > len - 1)) && left_end=$((len - 1))

            local right_end=$((i + 2 * run_len - 1))
            ((right_end > len - 1)) && right_end=$((len - 1))

            if ((left_end < right_end)); then
                merge $i $left_end $right_end
            fi
        done

        run_len=$((2 * run_len))
    done
}

# Test the Tim Sort with an example array
arr=(9 4 3 10 7 8 2 1 6 5)
echo "Original Array: ${arr[@]}"
tim_sort
echo "Sorted Array: ${arr[@]}"
