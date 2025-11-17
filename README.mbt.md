# KCN-judu/type_unification

This is a type unification library written in MoonBit.
一个使用 MoonBit 语言编写的类型合一（Type Unification）库。

## 📖 简介 Intro

This project is a type unification library implemented purely in MoonBit. Type unification is a core algorithm in the compilers and type checkers of statically typed languages. Its primary purpose is to find a substitution that makes two type expressions equal.

本项目是一个MoonBit实现的类型合一算法库。类型合一是在静态类型语言的编译器和类型检查器中，用于解决类型变量约束的核心算法。简单来说，它的目的是找到一个替换方案（substitution），使得两个或多个类型表达式相等。

For example, given the types `(T, int)` and `(string, U)`, the unification algorithm would find the substitution `{T = string, U = int}`. This library provides a foundational module for building a type inference system for a programming language.

例如，对于 `(T, int)` 和 `(string, U)` 这两个类型，合一算法会找到替换解 `{T = string, U = int}`。这个库为构建编程语言的类型推断（Type Inference）系统提供了基础模块。

**Note** : In a scenario like unifying `(T, int)` and `(string, T)`, it's assumed that generic type `T` in each type expression exists in a separate context.

**注意**：在合一 `(T, int)` 和 `(string, T)` 的场景中，我们假设两个类型表达式中的泛型 `T` 处于不同的上下文中。

## ✨ 功能特性 features

This library provides the following features:

* Type Algebraic Data Types (ADTs)
* Type ADTs' Eq and Show implementations
* Type Unification

本项目目前已经实现以下功能：

* 类型的代数数据类型(ADT)
* 类型代数数据类型的Eq和Show实现
* 类型合一算法

## 🛠️ 使用方法 Usage

To use this library, you need to import it into your project.

要使用这个库，你需要将其导入到你的项目中。

unification algorithm is provided as a function `unification()`

类型合一算法作以函数 `unification()` 的形式提供。
